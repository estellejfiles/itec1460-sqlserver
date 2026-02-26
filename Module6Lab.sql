-- #1 create Authors table with four columns
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

-- #2 create Books table with five columns
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    PublicationYear INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- #3 insert data into the Authors table & Books table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
VALUES
(1, 'Jane', 'Austen', '1775-12-16'),
(2, 'George', 'Orwell', '1903-06-25'),
(3, 'J.K.', 'Rowling', '1965-07-31'),
(4, 'Ernest', 'Hemingway', '1899-07-21'),
(5, 'Virginia', 'Wolf', '1882-01-25');
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To the Lighthouse', 5, 1927, 13.99);
GO

-- #4 create a simple view that combines info from Authors & Books
CREATE VIEW BookDetails AS
SELECT
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    b.PublicationYear,
    b.Price
FROM
    Books b
JOIN
    Authors a ON b.AuthorID = a.AuthorID;
GO

-- #5 create a filtered view that shows books published after 1990
CREATE VIEW RecentBooks AS
SELECT
    BookID,
    Title,
    PublicationYear,
    Price
FROM
    Books
WHERE
    PublicationYear > 1990;
GO

-- #6 create view with calculated fields for number of books & average price per author
CREATE VIEW AuthorStats AS
SELECT
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    COUNT(b.BookID) AS BookCount,
    AVG(b.Price) AS AverageBookPrice
FROM
    Authors a
LEFT JOIN
    Books b ON a.AuthorID = b.AuthorID
GROUP BY
    a.AuthorID, a.FirstName, a.LastName;
GO

-- #7 query the views
-- a) retrieve all records from BookDetails view
SELECT Title, Price FROM BookDetails;
-- b) list all books from RecentBooks view
SELECT * FROM RecentBooks;
-- c) show statistics for each author from AuthorStats view
SELECT * FROM AuthorStats;
GO

-- #8 create updateable view for author names
CREATE VIEW AuthorContactInfo AS
SELECT
    AuthorID,
    FirstName,
    LastName
FROM
    Authors;
GO
-- update author's first name using the view
UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorID = 3;
GO
-- query the view
SELECT * FROM AuthorContactInfo;

-- #9 create an audit trigger to log all price changes in Books in a new audit table
-- create audit table
CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO
-- create trigger
CREATE TRIGGER trg_BookPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT 
            i.BookID,
            d.Price,
            i.Price
        FROM inserted i
        JOIN deleted d ON i.BookID = d.BookID
    END
END;
-- update a book's price to trigger the audit
UPDATE Books
SET Price = 14.99
WHERE BookID = 1;
-- check audit table
SELECT * FROM BookPriceAudit;
GO





-- PART TWO:

-- #2 create BookReviews table with six columns
CREATE TABLE BookReviews (
    ReviewID INT PRIMARY KEY,
    BookID INT,
    CustomerID NCHAR(5),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- -- #3 create a view that shows title, # of reviews, average rating, & most recent date
-- CREATE VIEW vw_BookReviewStats AS
-- SELECT
--     b.Title,
--     COUNT(r.ReviewID) AS ReviewCount,
--     AVG(r.Rating) AS AverageRating,
--     MAX(r.ReviewDate) AS MostRecentReview
-- FROM
--     BookReviews r
-- JOIN
--     Books b ON b.BookID = r.BookID;
-- GO