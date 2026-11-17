CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

--Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
 Book_ID SERIAL PRIMARY KEY,
 Title VARCHAR(100),
 Author VARCHAR(100),
 Genre VARCHAR(50),
 Published_Year INT,
 Price NUMERIC(10,2),
 Stock INT
 );
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers(
    Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
    Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
	);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
  Order_ID SERIAL PRIMARY KEY,
  Customer_ID INT REFERENCES Customers(CUSTOMER_ID),
  Book_ID INT REFERENCES Books(Book_ID),
  Order_Date DATE,
  Quantity INT,
  Total_Amount NUMERIC(10, 2)
  );
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--Import Data into Books Table
COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'C:\Users\HP\Downloads\Book.csv'
CSV HEADER ;

--Import Data into Customers Table
COPY Customers (Customer_ID, Name,Email,Phone,City,Country)
FROM 'C:\Users\HP\Downloads\Customers.csv'
CSV HEADER;

--Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\HP\Downloads\Orders.csv'
CSV HEADER;

--1) RETRIEVE ALL BOOKS IN THE "FICTION" GENRE.
SELECT * FROM Books 
WHERE GENRE='Fiction';

--2) Find Books published after 1950.
SELECT * FROM Books
WHERE Published_Year>1950;

--3) List all the customers from Canada.
Select * From Customers
Where Country='Canada';

--4) Show orders placed in 2023.
Select * FROM Orders
WHERE Order_Date between '2023-11-01' And '2023-11-30';

--5) Retrieve the total stock of books available.
SElect Sum(stock) AS Total_Stock
FRom Books;

--6) Find the details of the most expenisve Book.
Select * FRom Books Order by Price Desc limit 1; 

--7) Show all customers who ordered more than 1 quantity of a bank
Select * from orders
where quantity >1;

--8) REtrieve  all orders  where the total amount exceed $20
 Select * from orders 
 where total_amount>20;

 --9) List all the genres available in the books table;
 SElect DISTINCT genre from Books;

 --10)  Find the book with the lowest stock;
 SElect * from Books Order by Stock asc limit 1;

 --11) Calcualte the total revenue generated  from all orders
 Select sum(total_amount) as revenue from orders;

 Advance Queries

 --1) Retrieve the total number of books sold for each  genre
 SElect * from orders;

 select b.genre, sum(o.quantity)
 from orders o 
 join books b on o.book_id = b. book_id
 group by b.genre;

 --2) Find the average  price of books in the "Fantasy" genre;
 SElect AVG(price) as Average_price
 from books
 where genre = 'fantasy';

  --3) List customers who have placed at least 2 orders;
  SElect * from customers;
  select * from orders;
  select o.customer_id, c.name,count(o.order_id) as order_count
  from orders o
  join customers c on o.customer_id=c.customer_id
  group by o.customer_id, c.name
  having count(order_id) >=2;

  --4) Find the most frequently ordered book;
  select  o.book_id, b.title, Count(o.order_id) as order_count
  from orders o
  join books b on o.book_id = b.book_id
  group by o.book_id , b.title
  order by  order_count desc limit 1;

  --5)show the top 3 most expensive  books of 'fantasy' genre.
  select  * from books
  where genre ='Fantasy'
  order by price desc limit 3

  --6) Retrieve the total quantity of books sold by each author;
  select b.author,sum(o.quantity) as total_books_sold
  from orders o
  join books b on o.book_id = b.book_id
  group by b.author;

  --7) List  the cities where customers who spent over $30 are located;
  select distinct c.city, total_amount 
  from orders o
  join customers c on o.customer_id = c.customer_id
  where o.total_amount > 30;

  --8) Find the customer who spent the most on orders
  select c.customer_id, c.name, Sum(o.total_amount) as total_spent
  from orders o
  join customers c on o.customer_id = c.customer_id
  group by c.customer_id, c.name
  order by total_spent desc limit 1;

  --9) calculate the stock remaining after fulfilling all orders;
select b.book_id, b.title, b.stock, COALESCE(sum(o.quantity),0) AS Order_quantity,
  b.stock-coalesce(sum(o.quantity),0)as remaining_quantity
from books b
left join orders o on b.book_id =o.book_id
group by b.book_id ORDER BY B.BOOK_ID;
 
 

 



