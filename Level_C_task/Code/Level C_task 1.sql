
CREATE TABLE Projects (
    Task_ID INT,
    Start_Date DATE,
    End_Date DATE
);
INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');

select *from Projects;

WITH CTE AS (
    SELECT *,
           DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY Start_Date), Start_Date) AS grp
    FROM Projects
)
SELECT 
    MIN(Start_Date) AS Project_Start, 
    MAX(End_Date) AS Project_End
FROM CTE
GROUP BY grp
ORDER BY 
    DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)),
    MIN(Start_Date);
