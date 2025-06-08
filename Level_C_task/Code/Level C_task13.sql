CREATE TABLE BU_Financials (
    BU_Name VARCHAR(50),
    Month_Year VARCHAR(7), -- Format: 'YYYY-MM'
    Cost DECIMAL(10,2),
    Revenue DECIMAL(10,2)
);
INSERT INTO BU_Financials VALUES
('TechBU', '2024-01', 100000, 150000),
('TechBU', '2024-02', 120000, 140000),
('TechBU', '2024-03', 110000, 160000),
('HRBU', '2024-01', 50000, 70000),
('HRBU', '2024-02', 60000, 80000),
('HRBU', '2024-03', 55000, 85000);
select *from BU_Financials;

SELECT 
    BU_Name,
    Month_Year,
    Cost,
    Revenue,
    CAST(Cost / Revenue AS DECIMAL(5,2)) AS Cost_Revenue_Ratio
FROM BU_Financials
ORDER BY BU_Name, Month_Year;
