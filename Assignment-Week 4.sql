-- STEP 1: Create tables

CREATE TABLE StudentDetails (
    StudentId BIGINT PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA FLOAT,
    Branch VARCHAR(10),
    Section CHAR(1)
);

CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(20) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

CREATE TABLE StudentPreference (
    StudentId BIGINT,
    SubjectId VARCHAR(20),
    Preference INT CHECK (Preference BETWEEN 1 AND 5),
    PRIMARY KEY (StudentId, Preference),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE Allotments (
    StudentId BIGINT PRIMARY KEY,
    SubjectId VARCHAR(20),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE UnallotedStudents (
    StudentId BIGINT PRIMARY KEY,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);

-- STEP 2: Insert data

-- Students
INSERT INTO StudentDetails VALUES
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');

-- Subjects
INSERT INTO SubjectDetails VALUES
('PO1491', 'Basics of Political Science', 2, 2),
('PO1492', 'Basics of Accounting', 60, 60),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 50, 50),
('PO1495', 'Automotive Trends', 60, 60);

-- Preferences
INSERT INTO StudentPreference VALUES
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5),

(159103037, 'PO1492', 1),
(159103037, 'PO1493', 2),
(159103037, 'PO1494', 3),
(159103037, 'PO1495', 4),
(159103037, 'PO1491', 5),

(159103038, 'PO1493', 1),
(159103038, 'PO1494', 2),
(159103038, 'PO1495', 3),
(159103038, 'PO1491', 4),
(159103038, 'PO1492', 5),

(159103039, 'PO1494', 1),
(159103039, 'PO1495', 2),
(159103039, 'PO1491', 3),
(159103039, 'PO1492', 4),
(159103039, 'PO1493', 5),

(159103040, 'PO1495', 1),
(159103040, 'PO1491', 2),
(159103040, 'PO1492', 3),
(159103040, 'PO1493', 4),
(159103040, 'PO1494', 5),

(159103041, 'PO1491', 1),
(159103041, 'PO1492', 2),
(159103041, 'PO1493', 3),
(159103041, 'PO1494', 4),
(159103041, 'PO1495', 5);

-- STEP 3: Create stored procedure

GO
CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    DELETE FROM Allotments;
    DELETE FROM UnallotedStudents;

    DECLARE @StudentId BIGINT, @SubjectId VARCHAR(20), @SeatsLeft INT, @Allocated BIT;

    DECLARE student_cursor CURSOR FOR
    SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    OPEN student_cursor;
    FETCH NEXT FROM student_cursor INTO @StudentId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Allocated = 0;
        DECLARE @Pref INT = 1;

        WHILE @Pref <= 5 AND @Allocated = 0
        BEGIN
            SELECT @SubjectId = SubjectId
            FROM StudentPreference
            WHERE StudentId = @StudentId AND Preference = @Pref;

            IF @SubjectId IS NOT NULL
            BEGIN
                SELECT @SeatsLeft = RemainingSeats
                FROM SubjectDetails
                WHERE SubjectId = @SubjectId;

                IF @SeatsLeft > 0
                BEGIN
                    INSERT INTO Allotments(StudentId, SubjectId)
                    VALUES (@StudentId, @SubjectId);

                    UPDATE SubjectDetails
                    SET RemainingSeats = RemainingSeats - 1
                    WHERE SubjectId = @SubjectId;

                    SET @Allocated = 1;
                END
            END

            SET @Pref = @Pref + 1;
        END

        IF @Allocated = 0
        BEGIN
            INSERT INTO UnallotedStudents(StudentId)
            VALUES (@StudentId);
        END

        FETCH NEXT FROM student_cursor INTO @StudentId;
    END

    CLOSE student_cursor;
    DEALLOCATE student_cursor;
END;
GO

-- STEP 4: Execute and show results
EXEC AllocateSubjects;

SELECT * FROM Allotments;
SELECT * FROM UnallotedStudents;

SELECT * FROM SubjectDetails;
SELECT * FROM UnallotedStudents;
