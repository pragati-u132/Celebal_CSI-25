CREATE TABLE EmployeeData (
    EmpID INT,
    SubBand VARCHAR(10)
);

INSERT INTO EmployeeData VALUES
(1, 'SB1'),
(2, 'SB1'),
(3, 'SB2'),
(4, 'SB2'),
(5, 'SB2'),
(6, 'SB3'),
(7, 'SB3'),
(8, 'SB3'),
(9, 'SB3');
select *from EmployeeData;

SELECT 
    SubBand,
    COUNT(*) AS Headcount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM EmployeeData
GROUP BY SubBand;
