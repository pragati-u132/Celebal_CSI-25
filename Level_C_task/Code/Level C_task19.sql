CREATE TABLE Employees (
    EmpID INT,
    Salary VARCHAR(20)  -- Stored as string to simulate missing zeros
);

INSERT INTO Employees VALUES
(1, '100000'),
(2, '90000'),
(3, '120000'),
(4, '80000'),
(5, '100500');
select *from Employees;

SELECT 
    CEILING(AVG(CAST(Salary AS FLOAT))) AS ActualAvg,
    CEILING(AVG(CAST(REPLACE(Salary, '0', '') AS FLOAT))) AS BrokenAvg,
    CEILING(AVG(CAST(Salary AS FLOAT))) - CEILING(AVG(CAST(REPLACE(Salary, '0', '') AS FLOAT))) AS Difference
FROM Employees;
