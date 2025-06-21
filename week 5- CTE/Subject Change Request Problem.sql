-- Create SubjectAllotments table
CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Is_Valid BIT
);

-- Create SubjectRequest table
CREATE TABLE SubjectRequest (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20)
);
-- Sample data for SubjectAllotments
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);
select *from SubjectAllotments;

-- Sample data for SubjectRequest
INSERT INTO SubjectRequest (StudentId, SubjectId)
VALUES ('159103036', 'PO1496');
select *from SubjectRequest;



GO
CREATE PROCEDURE ProcessSubjectRequests
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentId VARCHAR(20), @RequestedSubject VARCHAR(20), @CurrentSubject VARCHAR(20);

    DECLARE request_cursor CURSOR FOR
    SELECT StudentId, SubjectId FROM SubjectRequest;

    OPEN request_cursor;
    FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubject;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get current valid subject
        SELECT @CurrentSubject = SubjectId
        FROM SubjectAllotments
        WHERE StudentId = @StudentId AND Is_Valid = 1;

        IF @CurrentSubject IS NULL
        BEGIN
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
            VALUES (@StudentId, @RequestedSubject, 1);
        END
        ELSE IF @CurrentSubject <> @RequestedSubject
        BEGIN
            UPDATE SubjectAllotments
            SET Is_Valid = 0
            WHERE StudentId = @StudentId AND Is_Valid = 1;

            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
            VALUES (@StudentId, @RequestedSubject, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubject;
    END

    CLOSE request_cursor;
    DEALLOCATE request_cursor;
END;
GO
-- output

EXEC ProcessSubjectRequests;
SELECT * FROM SubjectAllotments WHERE StudentId = '159103036';
