CREATE DATABASE onlinebookstore; 


drop table if exists books;

create table books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
)

SELECT * FROM books;
-- Second file import
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR(150)
)

SELECT * FROM customers;

-- Third file import
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
Order_ID serial primary key,
Customer_ID int references customers(customer_id),
Book_ID int references books(book_id),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
)

SELECT * FROM orders;


-- Q 1 Retrieve all books in the 'Fiction' Genre;
select * from books
where genre = 'Fiction';

-- Q 2 find the books published after the 1950 year
select * from books
where published_year > 1950;

-- Q 3 list all customer from the Canada
SELECT * FROM customers
WHERE country = 'Canada';

-- Q 4 show orders placed in november 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Q 5 Retrieve the total stock of books available 
SELECT SUM(stock) as total_stock FROM books;

-- Q 6 Find the detail of most expensive book
SELECT * FROM books
ORDER BY price DESC
LIMIT 1;

-- Q 7  Show the all customer who ordered more than 1 quantity of a book
SELECT * FROM orders
WHERE quantity > 1
ORDER BY  quantity;

-- Q 8 retrieve all orders  where the total amount more than 20
SELECT * FROM orders
WHERE total_amount > 20;

-- Q 9 list all genre with count available  in the books table
SELECT genre, count(genre) as total_genre 
FROM books
GROUP BY genre;

-- Q 10 find the book with the lowest stock 
SELECT * FROM books
ORDER BY stock asc
LIMIT 1;


-- Q 11 calculate the total revenue generated from all orders
SELECT sum(total_amount) total_revenue
FROM orders;


-- Advance quary

-- Q 1 retrieve total number of sold quantity each genre?
SELECT books.genre as genre, sum(orders.quantity) as total_sold
FROM books
JOIN orders ON orders.book_id = books.book_id
GROUP BY genre;


-- Q 2 find the average price of book in the 'Fantasy' genre
SELECT round(avg(price),2) as average
FROM books
WHERE genre = 'Fantasy';

-- Q 3 list customer who have placed least 2 orders
SELECT c.name,count(o.order_id) as ordered
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING count(o.order_id) >= 2;

-- Q 4 Find the most frequently ordered books;
SELECT o.book_id,b.title,COUNT(o.order_id) as frequently_ordered
FROM orders  o
JOIN books b ON o.book_id = b.book_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- Q 5 Show the top 3 most expensive book of FANTASY genre?
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- Q 6 Retrieve the total quantity of books sold by each author
SELECT b.author , SUM(o.quantity) as total_sold
FROM orders o
JOIN books b ON  o.book_id = b.book_id
GROUP BY b.author
ORDER BY total_sold DESC;

-- Q 7 list the cities where customers who spent over $30 are located
SELECT c.name,c.city,o.total_amount
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.total_amount > 30
ORDER BY o.total_amount DESC;

-- Q 8 find the customers who spent most on orders
SELECT c.customer_id,c.name , SUM(o.total_amount) as total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- Q 9  Calculate the stock after fullfiling all orders
SELECT b.book_id,b.title,b.stock,COALESCE(sum(o.quantity),0) AS sell_stocks,
b.stock-COALESCE(sum(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ASC;