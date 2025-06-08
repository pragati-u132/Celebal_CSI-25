CREATE TABLE Employees (
    EmpID INT,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'A', 50000),
(2, 'B', 70000),
(3, 'C', 60000),
(4, 'D', 80000),
(5, 'E', 90000),
(6, 'F', 75000),
(7, 'G', 67000);
select *from Employees;

SELECT EmpID, EmpName, Salary
FROM (
    SELECT *, RANK() OVER (PARTITION BY 1 ORDER BY Salary DESC) AS rnk
    FROM Employees
) AS Ranked
WHERE rnk <= 5;
