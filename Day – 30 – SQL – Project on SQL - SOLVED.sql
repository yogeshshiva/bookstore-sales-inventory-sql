CREATE Table Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(500),
Author Varchar(500),
Genre Varchar(500),
Publised_Year Int,
Price Numeric(10,2),
Stock Int
);

CREATE Table Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR(150)
);


CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
Select * FROM Books WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books WHERE Publised_Year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'; -- If only nov month in 2023
SELECT * FROM Orders WHERE Order_Date >= '2023-11-01'; -- if greater then or equal to nov month in 2023


-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_Stock FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books WHERE Price = (SELECT MAX(Price) FROM Books);
SELECT * FROM Books ORDER BY Price DESC LIMIT 1; -- Note:- if we have 2 most expensive book then it will skip another one so in this senerio this query is not usefull.

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT c.Name, o.Quantity FROM Customers c JOIN Orders o ON c.Customer_ID = o.Customer_ID WHERE o.Quantity > 1; -- if show only customer name with number of quantity.
SELECT c.*, o.Quantity FROM Customers c JOIN Orders o ON c.Customer_ID = o.Customer_ID WHERE o.Quantity > 1; -- if show all details from customer.

-- 8) Retrieve all orders where the total amount exceeds ₹20:
SELECT * FROM Orders WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT(Genre) FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books WHERE Stock = (SELECT MIN(Stock) FROM Books);

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- Advance Questions : 
-- 1) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS Total_Sold FROM Books b JOIN Orders o ON b.book_ID = o.book_ID GROUP BY 1;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT ROUND(AVG(Price),2) AS Average_Price FROM Books WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT c.*, Count(o.Customer_ID) AS Total_Orders FROM Customers c JOIN Orders o ON c.Customer_ID = o.Customer_ID GROUP BY 1 
HAVING COUNT(o.Customer_ID) >= 2;

-- 4) Find the most frequently ordered book:
SELECT b.Title, COUNT(o.Book_ID) AS Total_Count FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID GROUP BY 1 ORDER BY Total_Count DESC;
SELECT Book_ID, COUNT(Order_ID) AS Order_Count FROM Orders GROUP BY Book_ID ORDER BY Order_Count DESC LIMIT 1;

 -- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.Author, SUM(o.Quantity) AS Total_Book_Sold FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID GROUP BY 1;

-- 7) List the cities where customers who spent over ₹30 are located:
SELECT DISTINCT c.City, o.Total_Amount FROM Customers c JOIN Orders o ON c.Customer_ID = o.Customer_ID WHERE o.Total_Amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.Name, SUM(o.Total_Amount) AS Total_Spent FROM Customers c JOIN Orders o ON c.Customer_ID = o.Customer_ID GROUP BY 1 ORDER BY 
Total_Spent DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
WITH CTE AS (SELECT b.*, SUM(o.Quantity) AS Sold FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID GROUP BY 1)
SELECT *, (Stock - Sold) AS Stock_Remaining FROM CTE;

SELECT b.*, COALESCE(b.stock - SUM(o.Quantity),0) AS Sold FROM Books b JOIN Orders o ON b.Book_ID = o.Book_ID GROUP BY 1;





