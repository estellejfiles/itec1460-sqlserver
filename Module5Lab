-- create a new customer in the Customers table
INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('STUDE', 'Student Company', 'Mary Lebens', 'USA');

-- verify that the record was inserted correctly
SELECT * FROM Customers WHERE CustomerID = 'STUDE';

-- create a new order for the customer we created
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry)
VALUES ('STUDE', 1, GETDATE(), 'USA');

-- verify that the order was entered
SELECT * FROM Orders WHERE CustomerID = 'STUDE';

-- change the contact name for our customer
UPDATE Customers SET ContactName = 'New Contact Name'
WHERE CustomerID = 'STUDE';

-- change the shipping country for our order
UPDATE Orders SET ShipCountry = 'New Country'
WHERE CustomerID = 'STUDE';

-- delete the order we inserted for the new customer
DELETE FROM Orders WHERE CustomerID = 'STUDE';

-- verify the order was deleted
SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';

-- remove test customer from the customers table
DELETE FROM Customers WHERE CustomerID = 'STUDE';

-- verify the customer was removed
SELECT * FROM Customers WHERE CustomerID = 'STUDE';

--PART 2:

-- exercise 1: insert new supplier
INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-up Foods', 'Estelle Peterson', 'Owner', 'USA');

-- verify supplier was inserted
SELECT * FROM Suppliers WHERE CompanyName = 'Pop-up Foods';

-- exercise 2: insert new product
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('House Special Pizza', '30', '2', '15.99', '50');

-- verify product was inserted
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- exercise 3: update product price
UPDATE Products
SET UnitPrice = '12.99'
WHERE ProductName = 'House Special Pizza';

-- verify product was updated
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- exercise 4: update units in stock and price
UPDATE Products
SET UnitsInStock = '25', UnitPrice = '17.99'
WHERE ProductName = 'House Special Pizza';

-- verify product was updated
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- exercise 5: delete pizza product
DELETE FROM Products WHERE ProductName = 'House Special Pizza';

-- verify product was deleted
SELECT * FROM Products WHERE ProductName = 'House Special Pizza';

-- PART 2 CHALLENGE:

-- insert new product
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('Frozen Chicken Wings', '30', '6', '10.99', '50');

-- verify product was inserted
SELECT * FROM Products WHERE ProductName = 'Frozen Chicken Wings';

-- update product price and inventory
UPDATE Products
SET UnitPrice = '9.99', UnitsInStock = '30'
WHERE ProductName = 'Frozen Chicken Wings';

-- verify product was updated
SELECT * FROM Products WHERE ProductName = 'Frozen Chicken Wings';

-- delete product
DELETE FROM Products WHERE ProductName = 'Frozen Chicken Wings';

-- verify product was deleted
SELECT * FROM Products WHERE ProductName = 'Frozen Chicken Wings';