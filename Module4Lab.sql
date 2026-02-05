-- Query #1: Using a Join to retrieve data from two tables
--          default JOIN type is INNER JOIN
SELECT C.CompanyName, O.OrderDate
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID;

-- Query #2: LEFT JOIN to show all of the customers, even those without any orders
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = O.CustomerID;

-- Query #3: Using Build-in Functions
SELECT OrderID, ROUND( SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalValue,
COUNT(*) AS NumberOfItems
FROM [Order Details]
GROUP BY OrderID
ORDER BY TotalValue DESC;

-- Query #4:
SELECT p.ProductID, p.ProductName,
COUNT(od.OrderID) AS TimesOrdered
FROM Products AS p
JOIN [Order Details] AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderID) > 10
ORDER BY TimesOrdered DESC;

-- Query #5:
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice) FROM Products
)
ORDER BY UnitPrice;

-- Query 6: Join three tables together
SELECT o.OrderID, o.OrderDate, p.ProductName, od.Quantity, od.UnitPrice
FROM Orders AS o
JOIN [Order Details] AS od ON o.OrderID = od.OrderID
JOIN Products AS p ON od.ProductID = p.ProductID
WHERE o.OrderID = 10248
ORDER BY p.ProductName;

-- Query #7: Get average product price by category
SELECT c.CategoryName,
ROUND(AVG(p.UnitPrice), 2) AS AveragePrice
FROM Categories AS c
JOIN Products AS p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY AveragePrice DESC;

-- Query #8: Count orders by employee
SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmployeeName, COUNT(o.OrderID) AS NumberOfOrders
FROM Employees AS e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY NumberOfOrders DESC;