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