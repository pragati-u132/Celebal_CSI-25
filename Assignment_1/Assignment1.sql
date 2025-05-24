-- 1. List of all customers
SELECT * FROM Sales.Customer;


-- 2. List of all customers where company name ends in N
SELECT c.CustomerID, s.Name
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';


-- 3. List of all customers who live in Berlin or London
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');

-- 4. List of all customers who live in UK or USA
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode IN ('US', 'GB');

-- 5. List of all products sorted by product name
SELECT * FROM Production.Product ORDER BY Name;

-- 6. List of all products where product name starts with an A
SELECT * FROM Production.Product WHERE Name LIKE 'A%';

-- 7. List of customers who ever placed an order
SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader;

-- 8. List of Customers who live in London and have bought chai
-- Chai likely doesn't exist; replace 'chai' with real product name if needed.
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE a.City = 'London' AND p.Name = 'Chai';

-- 9. List of customers who never place an order
SELECT * 
FROM Sales.Customer 
WHERE CustomerID NOT IN (SELECT CustomerID FROM Sales.SalesOrderHeader);

-- 10. List of customers who ordered Tofu
SELECT DISTINCT c.CustomerID
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

-- 11. Details of first order of the system
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

-- 12. Find the details of most expensive order date
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 13. For each order get the OrderID and Average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 14. For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- 15. Get a list of all managers and total number of employees who report to them
SELECT m.BusinessEntityID AS ManagerID, p.FirstName, p.LastName, COUNT(e.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName;

-- 16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- 17. List of all orders placed on or after 1996/12/31
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

-- 18. List of all orders shipped to Canada
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Canada';

-- 19. List of all orders with order total > 200
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- 20. List of countries and sales made in each country
SELECT cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;

-- 21. List of Customer ContactName and number of orders they placed
SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

-- 22. List of customer contactnames who have placed more than 3 orders
SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

-- 23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT pr.ProductID, pr.Name
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE pr.DiscontinuedDate IS NOT NULL
AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- 24. List of employee firstname, lastname, supervisor FirstName, LastName
SELECT e.BusinessEntityID AS EmployeeID, pe.FirstName AS EmpFirst, pe.LastName AS EmpLast,
       ps.FirstName AS SupFirst, ps.LastName AS SupLast
FROM HumanResources.Employee e
JOIN Person.Person pe ON e.BusinessEntityID = pe.BusinessEntityID
LEFT JOIN HumanResources.Employee s ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
LEFT JOIN Person.Person ps ON s.BusinessEntityID = ps.BusinessEntityID;

-- 25. List of Employees id and total sale conducted by employee
SELECT e.BusinessEntityID, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson sp
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY e.BusinessEntityID;

-- 26. List of employees whose FirstName contains character a
SELECT p.FirstName, p.LastName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName LIKE '%a%';

-- 27. List of managers who have more than four people reporting to them
SELECT m.BusinessEntityID AS ManagerID, COUNT(e.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
GROUP BY m.BusinessEntityID
HAVING COUNT(e.BusinessEntityID) > 4;

-- 28. List of Orders and ProductNames
SELECT soh.SalesOrderID, p.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- 29. List of orders placed by the best customer
WITH CustomerSales AS (
    SELECT CustomerID, SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
BestCustomer AS (
    SELECT TOP 1 CustomerID
    FROM CustomerSales
    ORDER BY TotalSales DESC
)
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN BestCustomer bc ON soh.CustomerID = bc.CustomerID;

-- 30. Orders placed by customers who do not have a Fax number
-- Fax is not stored directly; workaround by checking Contact info
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE p.BusinessEntityID NOT IN (
  SELECT BusinessEntityID FROM Person.PersonPhone WHERE PhoneNumberTypeID = 3
);

-- 31. Postal codes where the product Tofu was shipped
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

-- 32. Product Names shipped to France
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'FR';

-- 33. ProductNames and Categories for supplier 'Specialty Biscuits, Ltd.'
SELECT prd.Name, pc.Name AS Category
FROM Production.Product prd
JOIN Production.ProductSubcategory psc ON prd.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON prd.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- 34. Products never ordered
SELECT * 
FROM Production.Product 
WHERE ProductID NOT IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 35. Products where units in stock < 10 and units on order = 0
SELECT p.ProductID, pi.LocationID, pi.Quantity
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE pi.Quantity < 10 AND p.SafetyStockLevel = 0;

-- 36. Top 10 countries by sales
SELECT TOP 10 sp.CountryRegionCode, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode
ORDER BY TotalSales DESC;

-- 37. Number of orders each employee has taken for customers with IDs between A and AO
-- This one needs clarification, assuming alphabetical AccountNumber
SELECT e.BusinessEntityID, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.AccountNumber BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;

-- 38. Orderdate of most expensive order
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 39. Product name and total revenue from that product
SELECT p.Name, SUM(sod.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name;

-- 40. Supplier ID and number of products offered
SELECT BusinessEntityID AS SupplierID, COUNT(ProductID) AS ProductCount
FROM Purchasing.ProductVendor
GROUP BY BusinessEntityID;

-- 41. Top 10 customers based on business (revenue)
SELECT TOP 10 soh.CustomerID, SUM(soh.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY TotalSpent DESC;

-- 42. Total revenue of the company
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;

