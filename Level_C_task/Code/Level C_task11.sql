CREATE TABLE Students (
    ID INT,
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

-- Students
INSERT INTO Students VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');
select *from Students;

-- Friends
INSERT INTO Friends VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 7);
select *from Friends;

-- Packages
INSERT INTO Packages VALUES
(1, 15.20),
(2, 10.06),
(3, 11.55),
(4, 12.12),
(7, 15.20);
select *from Packages;

SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages sp ON s.ID = sp.ID
JOIN Packages fp ON f.Friend_ID = fp.ID
WHERE sp.Salary < fp.Salary
ORDER BY fp.Salary;
