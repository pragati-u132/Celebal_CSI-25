CREATE TABLE dim_customer_history (
    CustomerID INT,
    Name VARCHAR(50),
    Address VARCHAR(100),
    ChangeDate DATETIME,
    ChangeType VARCHAR(50)
)

-- Clean all existing data
DELETE FROM dim_customer
DELETE FROM stg_customer
DELETE FROM dim_customer_history

-- Insert initial records in main dimension table
INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
VALUES
(1, 'Alice', 'Pune', '2024-01-01', NULL, 1, NULL),
(2, 'Bob', 'Mumbai', '2024-01-01', NULL, 1, NULL)

-- New incoming data
INSERT INTO stg_customer (CustomerID, Name, Address)
VALUES
(1, 'Alice', 'Pune'),        -- No change
(2, 'Bob', 'Delhi'),         -- Address changed
(3, 'Charlie', 'Nagpur')     -- New customer

DROP PROCEDURE IF EXISTS scd_type_4
GO

CREATE PROCEDURE scd_type_4
AS
BEGIN
    DECLARE @ChangeDate DATETIME
    SET @ChangeDate = GETDATE()

    -- Archive changed records to history table
    INSERT INTO dim_customer_history (CustomerID, Name, Address, ChangeDate, ChangeType)
    SELECT d.CustomerID, d.Name, d.Address, @ChangeDate, 'UPDATED'
    FROM dim_customer d
    INNER JOIN stg_customer s ON d.CustomerID = s.CustomerID
    WHERE d.Name <> s.Name OR d.Address <> s.Address

    -- Update current dimension table
    UPDATE d
    SET d.Name = s.Name,
        d.Address = s.Address
    FROM dim_customer d
    INNER JOIN stg_customer s ON d.CustomerID = s.CustomerID
    WHERE d.Name <> s.Name OR d.Address <> s.Address

    -- Insert new customers into dimension table
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent, PrevAddress)
    SELECT s.CustomerID, s.Name, s.Address, @ChangeDate, NULL, 1, NULL
    FROM stg_customer s
    WHERE NOT EXISTS (
        SELECT 1 FROM dim_customer d WHERE d.CustomerID = s.CustomerID
    )
END
GO

EXEC scd_type_4
SELECT * FROM dim_customer
SELECT * FROM dim_customer_history
