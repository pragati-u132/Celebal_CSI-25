CREATE TABLE BU_Cost (
    BU_Name VARCHAR(50),
    Month_Year VARCHAR(7),  -- Format: YYYY-MM
    Headcount INT,
    CostPerEmployee DECIMAL(10,2)
);

INSERT INTO BU_Cost VALUES
('TechBU', '2024-01', 10, 80000),
('TechBU', '2024-01', 20, 90000),
('TechBU', '2024-02', 15, 85000),
('TechBU', '2024-02', 25, 95000),
('HRBU', '2024-01', 5, 60000),
('HRBU', '2024-01', 10, 70000),
('HRBU', '2024-02', 8, 65000),
('HRBU', '2024-02', 12, 75000);
select *from BU_Cost;

SELECT 
    BU_Name,
    Month_Year,
    CAST(SUM(Headcount * CostPerEmployee) * 1.0 / SUM(Headcount) AS DECIMAL(10,2)) AS WeightedAvgCost
FROM BU_Cost
GROUP BY BU_Name, Month_Year
ORDER BY BU_Name, Month_Year;
