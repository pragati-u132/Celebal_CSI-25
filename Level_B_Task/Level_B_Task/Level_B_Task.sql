-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CompanyName VARCHAR(100)
);

-- Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(100)
);

-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(50),
    UnitPrice MONEY,
    UnitsInStock INT,
    ReorderLevel INT,
    Discontinued BIT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Order Details
CREATE TABLE [Order Details] (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity INT,
    Discount FLOAT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
### Sample Data
-- Customers
INSERT INTO Customers VALUES (1, 'Acme Corp'), (2, 'Globex Ltd');

-- Categories
INSERT INTO Categories VALUES (1, 'Beverages'), (2, 'Electronics');

-- Suppliers
INSERT INTO Suppliers VALUES (1, 'Nestle'), (2, 'Sony');

-- Products
INSERT INTO Products VALUES
(1, 'Coffee', 1, 1, '10 boxes', 15.00, 100, 20, 0),
(2, 'TV', 2, 2, '1 unit', 300.00, 10, 5, 0);

-- Orders
INSERT INTO Orders VALUES 
(101, 1, GETDATE()-1),  -- yesterday
(102, 2, GETDATE());    -- today

-- Order Details
INSERT INTO [Order Details] VALUES (101, 1, 15.00, 5, 0.1);

### 2. Stored Procedures
a. InsertOrderDetails

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    DECLARE @InStock INT, @ReorderLevel INT, @DefaultPrice MONEY;

    SELECT @InStock = UnitsInStock, 
           @ReorderLevel = ReorderLevel, 
           @DefaultPrice = UnitPrice
    FROM Products WHERE ProductID = @ProductID;

    IF @InStock IS NULL
    BEGIN
        PRINT 'Invalid ProductID';
        RETURN;
    END

    IF @InStock < @Quantity
    BEGIN
        PRINT 'Not enough stock.';
        RETURN;
    END

    IF @UnitPrice IS NULL
        SET @UnitPrice = @DefaultPrice;

    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    IF (@InStock - @Quantity) < @ReorderLevel
        PRINT 'Warning: Stock dropped below reorder level.';
END

  
b. UpdateOrderDetails
  
CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount FLOAT = NULL
AS
BEGIN
    UPDATE [Order Details]
    SET 
        UnitPrice = ISNULL(@UnitPrice, UnitPrice),
        Quantity = ISNULL(@Quantity, Quantity),
        Discount = ISNULL(@Discount, Discount)
    WHERE OrderID = @OrderID AND ProductID = @ProductID;
END

  
c. GetOrderDetails
CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM [Order Details] WHERE OrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist';
        RETURN 1;
    END

    SELECT * FROM [Order Details] WHERE OrderID = @OrderID;
END

  
d. DeleteOrderDetails
CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM [Order Details] 
                   WHERE OrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Invalid OrderID or ProductID';
        RETURN -1;
    END

    DELETE FROM [Order Details] 
    WHERE OrderID = @OrderID AND ProductID = @ProductID;
END
  
### 3. Functions
a. MM/DD/YYYY

CREATE FUNCTION fn_Format_MMDDYYYY (@date DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CONVERT(VARCHAR(10), @date, 101);
END

  
b. YYYYMMDD
CREATE FUNCTION fn_Format_YYYYMMDD (@date DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    RETURN CONVERT(VARCHAR(8), @date, 112);
END

  
### 4. Views
a. vwCustomerOrders
  
CREATE VIEW vwCustomerOrders AS
SELECT 
    c.CompanyName, o.OrderID, o.OrderDate, 
    od.ProductID, p.ProductName, od.Quantity, od.UnitPrice,
    od.Quantity * od.UnitPrice AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;


b. Orders placed yesterday

CREATE VIEW vwCustomerOrdersYesterday AS
SELECT 
    c.CompanyName, o.OrderID, o.OrderDate, 
    od.ProductID, p.ProductName, od.Quantity, od.UnitPrice,
    od.Quantity * od.UnitPrice AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate = CAST(GETDATE() - 1 AS DATE);

c. MyProducts

CREATE VIEW MyProducts AS
SELECT 
    p.ProductID, p.ProductName, p.QuantityPerUnit, p.UnitPrice,
    s.CompanyName, c.CategoryName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0;

### 5. Triggers
a. Delete order with cascade

CREATE TRIGGER trg_DeleteOrderCascade
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM [Order Details]
    WHERE OrderID IN (SELECT OrderID FROM DELETED);

    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM DELETED);
END

b. Check stock before insert

CREATE TRIGGER trg_StockCheck
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ProductID INT, @Quantity INT, @Stock INT;

    SELECT TOP 1 @ProductID = ProductID, @Quantity = Quantity FROM INSERTED;
    SELECT @Stock = UnitsInStock FROM Products WHERE ProductID = @ProductID;

    IF @Stock < @Quantity
    BEGIN
        PRINT 'Insufficient stock';
        RETURN;
    END

    INSERT INTO [Order Details]
    SELECT * FROM INSERTED;

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;
END

