-- Type 2 scd
-- Clean tables
DELETE FROM dim_customer
DELETE FROM stg_customer

-- Insert into dim_customer
INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent)
VALUES
(1, 'Alice', 'Pune', '2024-01-01', NULL, 1),
(2, 'Bob', 'Mumbai', '2024-01-01', NULL, 1)

-- Insert into stg_customer
INSERT INTO stg_customer (CustomerID, Name, Address)
VALUES
(1, 'Alice', 'Pune'),
(2, 'Bob', 'Delhi'),
(3, 'Charlie', 'Nagpur')


--Run separate
--or use go

DROP PROCEDURE IF EXISTS scd_type_2
GO

CREATE PROCEDURE scd_type_2
AS
BEGIN
    DECLARE @CurrentDate DATETIME
    SET @CurrentDate = GETDATE()

    -- Step 1: Mark old record as inactive
    UPDATE d
    SET d.EndDate = @CurrentDate,
        d.IsCurrent = 0
    FROM dim_customer d
    INNER JOIN stg_customer s ON d.CustomerID = s.CustomerID
    WHERE d.IsCurrent = 1 AND (d.Name <> s.Name OR d.Address <> s.Address)

    -- Step 2: Insert new version or new customers
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent)
    SELECT s.CustomerID, s.Name, s.Address, @CurrentDate, NULL, 1
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID AND d.IsCurrent = 1
    WHERE d.CustomerID IS NULL OR (d.Name <> s.Name OR d.Address <> s.Address)
END
GO



--***************
EXEC scd_type_2

SELECT * FROM dim_customer
