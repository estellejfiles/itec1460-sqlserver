Use Northwind;
GO

-- procedure 1: no parameters
-- only prints welcome message
CREATE OR ALTER PROCEDURE WelcomeMessage
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Welcome to the Northwind database!';
END
GO
-- test it
EXEC WelcomeMessage;
GO

-- procedure 2: one input parameter 
-- retrieves company name by customer ID
CREATE OR ALTER PROCEDURE GetCustomerName
    @CustomerID NCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompanyName NVARCHAR(40);

    -- retrieve company name from database table
    SELECT @CompanyName = CompanyName
    FROM Customers
    WHERE CustomerID = @CustomerID;

    -- boolean condition to check if company name was found
    IF @CompanyName IS NULL
        PRINT 'Customer not found.';
    ELSE
        PRINT 'Company Name: ' + @CompanyName;
END
GO

-- test with a valid customer
EXEC GetCustomerName @CustomerID = 'ALFKI';
GO
-- test with an invalid customer
EXEC GetCustomerName @CustomerID = 'ZZZZZ';
GO

-- procedure 3: one input parameter, one output parameter
-- returns the total number of orders for a given customer
CREATE OR ALTER PROCEDURE GetCustomerOrderCount
    @CustomerID NCHAR(5),
    @OrderCount INT OUTPUT
AS
BEGIN
    -- no output for the number of rows
    SET NOCOUNT ON;
    -- retrieve order count (row count) from Orders table for customerID passed in
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END
GO

-- declare the @OrderCount variable to hold the output value
DECLARE @OrderCount INT;
-- test the stored procedure
EXEC GetCustomerOrderCount
    @CustomerID = 'ALFKI',
    @OrderCount = @OrderCount OUTPUT;
-- print the number of orders at cmd line
PRINT 'Order count for ALFKI: ' + CAST(@OrderCount AS NVARCHAR(10));
GO

-- procedure 4: one input parameter, one output parameter
-- retrieves OrderID and returns calculated order total
CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,  
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    -- supresses number of rows message you usually see
    SET NOCOUNT ON;
    -- retrieve data from table and calculate total order amount
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;
    -- error handling for the case where the total amount is null
    IF @TotalAmount IS NULL
    BEGIN
        -- set total amount to 0
        SET @TotalAmount = 0;
        -- display message to user
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        -- return to end the procedure
        RETURN;
    END
    -- only print total amount if there is a value (not null)
    PRINT 'Total for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ': $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- test with a valid order
DECLARE @TotalAmount MONEY;
EXEC CalculateOrderTotal
    @OrderID = 10248,
    @TotalAmount = @TotalAmount OUTPUT;
PRINT 'Returned total: $' + CAST(@TotalAmount AS NVARCHAR(20));
GO

-- test with an invalid order
DECLARE @TotalAmount MONEY;
EXEC CalculateOrderTotal
    @OrderID = 99999,
    @TotalAmount = @TotalAmount OUTPUT;
PRINT 'Returned total: $' + CAST(@TotalAmount AS NVARCHAR(20));
GO


-- PART TWO:
USE Northwind;
GO
-- =============================================
-- Part 2, Procedure 1: GetProductName
-- =============================================
CREATE OR ALTER PROCEDURE GetProductName
    @ProductID INT,
    @ProductName NVARCHAR(40) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- write a SELECT statement that sets @ProductName equal to the ProductName column
    -- from the Products table where ProductID matches @ProductID.
    SELECT @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID;

    IF @ProductName IS NULL
        PRINT 'Product not found.';
    ELSE
        PRINT 'Product Name: ' + @ProductName;
END
GO

-- test the procedure
DECLARE @ProductName NVARCHAR(40);
EXEC GetProductName
    @ProductID = 1,
    @ProductName = @ProductName OUTPUT;
GO

-- =============================================
-- Part 2, Procedure 2: GetEmployeeOrderCount
-- =============================================
CREATE OR ALTER PROCEDURE GetEmployeeOrderCount
    @EmployeeID INT,
    @OrderCount INT OUTPUT
AS
BEGIN
    -- 1. Turn off row count messages (SET NOCOUNT ON)
    SET NOCOUNT ON;
    -- 2. Write a SELECT statement that counts orders for this employee and stores the result in @OrderCount
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE EmployeeID = @EmployeeID;
    -- 3. Print a message showing the employee ID and their order count.
    --    Hint: Use CAST to convert INT values to NVARCHAR for PRINT.
    PRINT 'Order Count for Employee ' + CAST(@EmployeeID AS NVARCHAR(10)) + ': ' + CAST(@OrderCount AS NVARCHAR(10));
END
GO

-- test it
DECLARE @OrderCount INT;
EXEC GetEmployeeOrderCount
    @EmployeeID = 5,
    @OrderCount = @OrderCount OUTPUT;
GO
-- SELECT EmployeeID, COUNT(*) AS OrderCount FROM Orders GROUP BY EmployeeID;


-- =============================================
-- Part 2, Procedure 3: CheckProductStock
-- =============================================
CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,
    @NeedsReorder BIT OUTPUT
AS
BEGIN
    -- 1. turn off row count messages
    SET NOCOUNT ON;
    -- declare relevant variables
    DECLARE @UnitsInStock INT;
    DECLARE @ReorderLevel INT;
    -- 3. write a select statement to access units in stock
    SELECT @UnitsInStock = UnitsInStock
    FROM Products
    WHERE ProductID = @ProductID;
    -- 4. set @NeedsReorder to 1 if units in stock is less than or equal to reorder level, otherwise set it to 0
    SELECT @ReorderLevel = ReorderLevel
    FROM Products
    WHERE ProductID = @ProductID;
    IF @UnitsInStock <= @ReorderLevel
        SET @NeedsReorder = 1;
    ELSE
        SET @NeedsReorder = 0;
    -- 5. print a message depending on if product needs to be reordered
    If @NeedsReorder = 1
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' needs reordering.';
    IF @NeedsReorder = 0
        PRINT 'Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' stock is OK.';
END
GO

-- test CheckProductStock
DECLARE @NeedsReorder BIT;
EXEC CheckProductStock
    @ProductID = 2,
    @NeedsReorder = @NeedsReorder OUTPUT;
PRINT 'Needs Reorder flag: ' + CAST(@NeedsReorder AS VARCHAR(1));
GO

-- SELECT ProductID, ProductName, UnitsInStock, ReorderLevel FROM Products WHERE ProductID = 2;