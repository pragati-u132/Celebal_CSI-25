ALTER TABLE dim_customer ADD PrevAddress VARCHAR(100)

-- Clear tables
DELETE FROM dim_customer
DELETE FROM stg_customer

-- Insert current data
INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent)
VALUES
(1, 'Alice', 'Pune', '2024-01-01', NULL, 1),
(2, 'Bob', 'Mumbai', '2024-01-01', NULL, 1)

-- Insert new incoming staging data
INSERT INTO stg_customer (CustomerID, Name, Address)
VALUES
(1, 'Alice', 'Pune'),        -- No change
(2, 'Bob', 'Delhi'),         -- Address changed
(3, 'Charlie', 'Nagpur')     -- New customer

DROP PROCEDURE IF EXISTS scd_type_3
GO

CREATE PROCEDURE scd_type_3
AS
BEGIN
    -- Insert new customers only
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
    SELECT s.CustomerID, s.Name, s.Address, GETDATE(), NULL, 1, NULL
    FROM stg_customer s
    WHERE NOT EXISTS (
        SELECT 1 FROM dim_customer d WHERE d.CustomerID = s.CustomerID
    )

    -- Update changed records: shift old address to PrevAddress
    UPDATE d
    SET d.PrevAddress = d.Address,
        d.Address = s.Address
    FROM dim_customer d
    INNER JOIN stg_customer s ON d.CustomerID = s.CustomerID
    WHERE d.Address <> s.Address
END
GO

EXEC scd_type_3
SELECT * FROM dim_customer
