select * from products;
select * from customers;
select * from orders;
select * from order_items;
select * from payments;
select * from product_reviews;

-- 1. Retrieve customer names and emails for email marketing
select name ,email from customers;


-- 2. View complete product catalog with all available details
select * from products;

-- 3. List all unique product categories
select distinct category from products;


-- 4. Show all products priced above ₹1,000
select * from products where price>1000;


-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
select * from products where price>2000 and price<5000;
select * from products where price between 2000 and 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
select * from customers where customer_id in(3,4,5);


-- 7. Identify customers whose names start with the letter ‘A’
select name from customers where name like'a%';
select * from customers where name like'a%';

-- 8. List electronics products priced under ₹3,000
select * from products where category='electronics' and price<3000;

-- 9. Display product names and prices in descending order of price
select name,price from products order by price desc;

-- 10. Display product names and prices, sorted by price and then by name
select name, price from products order by price desc,name asc;



-- level 2
-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
select * from orders where customer_id is null;

-- 2. Display customer names and emails using column aliases for frontend readability
select name as customer_name,email as customer_email from customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
select name,price*stock_quantity as total_price from products;

-- 4. Combine customer name and phone number in a single column
select concat(name," | ",phone) as contact_info from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
select date(order_date )from orders;

-- 6. List products that do not have any stock left
select * from products where stock_quantity<=0;




-- level 3
-- 1. Count the total number of orders placed
select count(*) as no_order from orders;

-- 2. Calculate the total revenue collected from all orders
select sum(total_amount) as Total_Revenue from orders;

-- 3. Calculate the average order value
select avg(total_amount) as avg_order_amt from orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id) as cutomers_count from orders;

-- 5. Find the number of orders placed by each customer
select customer_id,count(total_amount) as order_count 
from orders group by customer_id;

-- 6. Find total sales amount made by each customer
select customer_id,sum(total_amount) as sales_amt 
from orders group by customer_id;

-- 7. List the number of products sold per category
select p.category,count(p.category) as category_count
from order_items oi
left join products p
on p.product_id=oi.product_id
group by p.category;

-- 8. Find the average item price per category
select category ,avg(price) from products
group by category;

-- 9. Show number of orders placed per day
select date(order_date),count(order_id) as order_count from orders
group by date(order_date);

-- 10. List total payments received per payment method
select method,sum(amount_paid) from payments group by method;




-- Level 4
-- 1. Retrieve order details along with the customer name (INNER JOIN)
select o.*,c.name
from orders o
inner join customers c
on o.customer_id= c.customer_id;


-- 2. Get list of products that have been sold (INNER JOIN with order_items)
select p.name as product_name,sum(oi.quantity) as total_quantity,sum(oi.item_price) as total_amt
from order_items oi
inner join products p
on p.product_id=oi.product_id
group by p.name;


-- 3. List all orders with their payment method (INNER JOIN)
select o.*,p.method
from orders o
inner join payments p
on o.order_id=p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
select c.customer_id,c.name, sum(total_amount)as amount_spent,count(total_amount) as order_count 
from orders o 
left join customers c
on c.customer_id= o.customer_id
group by c.customer_id order by c.customer_id asc ;

-- 5. List all products along with order item quantity (LEFT JOIN)
select p.name as product_name,sum(oi.quantity) as total_quantity
from order_items oi
left join products p
on p.product_id=oi.product_id
group by p.name order by total_quantity desc;


-- 6. List all payments including those with no matching orders (RIGHT JOIN)
select p.*,o.total_amount as amt_as_per_orders
from orders o
right join payments p
on p.order_id=o.order_id;

-- 7. Combine data from three tables: customer, order, and payment
select c.*, o.*, p.*
from orders o
left join customers c
on o.customer_id =c.customer_id
left join payments p
on o.order_id = p.order_id;

-- Level 5
-- 1. List all products priced above the average product price
select * from products where price > (select avg(price) from products);

-- 2. Find customers who have placed at least one order
select distinct customer_id from orders;

-- 3. Show orders whose total amount is above the average for that customer
select * 
from orders o
where total_amount >
(select avg(total_amount) from orders
where customer_id=o.customer_id);

-- 4. Display customers who haven’t placed any orders
select name from customers where customer_id not in
(select customer_id from orders);

-- 5. Show products that were never ordered
select name from products where product_id not in 
(select product_id from orders);


-- 6. Show highest value order per customer
select customer_id, max(total_amount) as highest_value from orders
group by customer_id;
-- 7. Highest Order Per Customer (Including Names)
select c.customer_id,c.name,max(o.total_amount) as Highest_order_amt
from orders o
left join customers c
on c.customer_id=o.customer_id
group by customer_id;

-- Level 6
-- 1.List all customers who have either placed an order or written a product review
select customer_id from orders
union
select customer_id from product_reviews;


-- 2. List all customers who have placed an order as well as reviewed a product
select distinct customer_id from orders where customer_id in
(select customer_id from product_reviews);