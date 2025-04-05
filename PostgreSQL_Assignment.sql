-- Active: 1743185346247@@127.0.0.1@5432@bookstore_db
-- crate books table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    published_year DATE NOT NULL
);

INSERT INTO books (id, title, author, price, stock, published_year) VALUES
(1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, '1999-10-30'),
(2, 'Clean Code', 'Robert C. Martin', 35.00, 5, '2008-08-01'),
(3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, '2014-12-27'),
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, '1999-07-08'),
(5, 'Database Design Principles', 'Jane Smith', 20.00, 0, '2018-03-15');
SELECT *,extract(YEAR FROM published_year) FROM books;
DROP Table books;

-- create customer table
CREATE Table customers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    joined_date DATE DEFAULT now()
);
INSERT INTO customers (name, email, joined_date) VALUES
    ('Alice', 'alice@email.com', '2023-01-10'),
    ('Bob', 'bob@email.com', '2022-05-15'),
    ('Charlie', 'charlie@email.com','2023-06-20');

SELECT * FROM customers;
DROP TABLE customers;
-- crate orders table 
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id),
    book_id INT NOT NULL REFERENCES books(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date DATE DEFAULT CURRENT_DATE
);
INSERT INTO orders (customer_id, book_id, quantity, order_date)
VALUES
    (1, 2, 1, '2024-03-10'),
    (2, 1, 1, '2024-02-20'),
    (1, 3, 2, '2024-03-05');

SELECT * FROM orders;



-- Find books that are out of stock
SELECT title FROM books WHERE stock = 0;

-- retrieve the most expensive books in the store,

SELECT *,extract(YEAR FROM published_year) FROM books WHERE price = (SELECT MAX(price) FROM books);



-- Find the total number of orders placed by each customer;
SELECT c.name AS customer_name, COUNT(o.id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;


-- Calculate the total revenue generated from all orders;
SELECT SUM(b.price * o.quantity) AS total_revenue
FROM orders o
JOIN books b ON o.book_id = b.id;


-- List all customer who have placed more than one order ; 
SELECT  c.name AS name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 1;

-- Find the average price of books in the store;
SELECT round(avg(price)) AS average_book_price FROM books;

-- increase the price of all books published before 2000 by 10%;
UPDATE books
SET price = price * 1.10
WHERE published_year < '2000-01-01';

-- delete customer who havent placed any orders;
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);
SELECT * FROM customers;
