-- Query A: show all suppliers from Germany
SELECT CompanyName, City FROM Suppliers
WHERE Country = 'Germany';

-- Query B: find all products under $20
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < 20;

-- Query C: find customers in London
SELECT CompanyName, ContactName, Phone FROM Customers
WHERE City = 'London';