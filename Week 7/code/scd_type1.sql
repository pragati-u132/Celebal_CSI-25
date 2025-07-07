-- Drop tables if they exist
DROP TABLE IF EXISTS dim_customer
DROP TABLE IF EXISTS stg_customer
GO

-- Create Dimension Table
CREATE TABLE dim_customer (
    CustomerID INT,
    Name VARCHAR(50),
    Address VARCHAR(100),
    StartDate DATETIME,
    EndDate DATETIME,
    IsCurrent BIT
)
GO

-- Create Staging Table
CREATE TABLE stg_customer (
    CustomerID INT,
    Name VARCHAR(50),
    Address VARCHAR(100)
)
GO

-- Insert existing records in dimension
INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent)
VALUES
(1, 'Alice', 'Pune', '2024-01-01', NULL, 1),
(2, 'Bob', 'Mumbai', '2024-01-01', NULL, 1)
GO

-- Insert incoming new data into staging
INSERT INTO stg_customer (CustomerID, Name, Address)
VALUES
(1, 'Alice', 'Pune'),         -- No change
(2, 'Bob', 'Delhi'),          -- Address changed
(3, 'Charlie', 'Nagpur')      -- New customer
GO

DROP PROCEDURE IF EXISTS scd_type_1
GO

CREATE PROCEDURE scd_type_1
AS
BEGIN
    -- Insert new customers (not in dim_customer)
    INSERT INTO dim_customer (CustomerID, Name, Address, StartDate, EndDate, IsCurrent)
    SELECT s.CustomerID, s.Name, s.Address, GETDATE(), NULL, 1
    FROM stg_customer s
    WHERE NOT EXISTS (
        SELECT 1 FROM dim_customer d WHERE d.CustomerID = s.CustomerID
    )

    -- Update changed records in-place
    UPDATE d
    SET d.Name = s.Name,
        d.Address = s.Address
    FROM dim_customer d
    INNER JOIN stg_customer s ON d.CustomerID = s.CustomerID
    WHERE d.Name <> s.Name OR d.Address <> s.Address
END
GO
EXEC scd_type_1
SELECT * FROM dim_customer
