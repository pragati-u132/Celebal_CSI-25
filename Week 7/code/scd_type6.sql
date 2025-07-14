-- Clear existing data
DELETE FROM dim_customer
DELETE FROM stg_customer

-- Insert into dimension
INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
VALUES
(1, 'Alice', 'Pune', '2024-01-01', NULL, 1, NULL),
(2, 'Bob', 'Mumbai', '2024-01-01', NULL, 1, NULL)

-- Insert staging data
INSERT INTO stg_customer (CustomerID, Name, Address)
VALUES
(1, 'Alice', 'Pune'),         -- No change
(2, 'Bob', 'Delhi'),          -- Address changed
(3, 'Charlie', 'Nagpur')      -- New customer


DROP PROCEDURE IF EXISTS scd_type_6
GO

CREATE PROCEDURE scd_type_6
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

    -- Step 2: Insert new version with PrevAddress (from previous record)
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
    SELECT s.CustomerID, s.Name, s.Address, @CurrentDate, NULL, 1, d.Address
    FROM stg_customer s
    INNER JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.IsCurrent = 0 AND (d.Name <> s.Name OR d.Address <> s.Address)

    -- Step 3: Insert truly new customers
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
    SELECT s.CustomerID, s.Name, s.Address, @CurrentDate, NULL, 1, NULL
    FROM stg_customer s
    WHERE NOT EXISTS (
        SELECT 1 FROM dim_customer d WHERE d.CustomerID = s.CustomerID
    )
END
GO

EXEC scd_type_6
SELECT * FROM dim_customer
