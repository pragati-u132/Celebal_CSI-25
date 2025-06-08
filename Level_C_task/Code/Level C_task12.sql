CREATE TABLE JobFamilyCost (
    JobFamily VARCHAR(50),
    Region VARCHAR(20), -- 'India' or 'International'
    Cost DECIMAL(10,2)
);
INSERT INTO JobFamilyCost VALUES
('Engineering', 'India', 100000),
('Engineering', 'International', 80000),
('HR', 'India', 40000),
('HR', 'International', 30000),
('Finance', 'India', 60000),
('Finance', 'International', 90000);
select *from JobFamilyCo
SELECT 
    JobFamily,
    Region,
    CAST(Cost * 100.0 / SUM(Cost) OVER(PARTITION BY JobFamily) AS DECIMAL(5,2)) AS Percentage
FROM JobFamilyCost
ORDER BY JobFamily, Region;
