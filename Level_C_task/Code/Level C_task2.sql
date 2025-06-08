CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Friends (
    ID INT,
    Friend_ID INT
);

CREATE TABLE Packages (
    ID INT,
    Salary FLOAT
);
-- Students table
INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');
select *from Students;

-- Friends table
INSERT INTO Friends (ID, Friend_ID) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 1);
select *from Friends;

-- Packages table
INSERT INTO Packages (ID, Salary) VALUES
(1, 15.20),
(2, 10.06),
(3, 11.55),
(4, 12.12);
select *from Packages;
SELECT S.Name
FROM Students S
JOIN Friends F ON S.ID = F.ID
JOIN Packages SP ON S.ID = SP.ID
JOIN Packages FP ON F.Friend_ID = FP.ID
WHERE FP.Salary > SP.Salary
ORDER BY FP.Salary;

