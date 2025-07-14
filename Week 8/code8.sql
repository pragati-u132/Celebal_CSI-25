CREATE TABLE DateAttributes (
    Date DATE PRIMARY KEY,
    DayOfWeek NVARCHAR(10),
    IsWeekend BIT,
    MonthName NVARCHAR(10),
    Quarter INT
);


go
CREATE PROCEDURE PopulateDateAttributes
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    ;WITH DateSequence AS (
        SELECT @StartDate AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateSequence
        WHERE DateValue < @EndDate
    )
    INSERT INTO DateAttributes (Date, DayOfWeek, IsWeekend, MonthName, Quarter)
    SELECT 
        DateValue,
        DATENAME(WEEKDAY, DateValue),
        CASE WHEN DATENAME(WEEKDAY, DateValue) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END,
        DATENAME(MONTH, DateValue),
        DATEPART(QUARTER, DateValue)
    FROM DateSequence
    OPTION (MAXRECURSION 366);
END;

EXEC PopulateDateAttributes '2020-07-14';

SELECT * FROM DateAttributes WHERE Date = '2020-07-14';
