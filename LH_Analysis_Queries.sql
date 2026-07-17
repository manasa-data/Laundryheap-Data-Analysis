-- Check row counts
SELECT 'customers'  AS table_name, COUNT(*) AS total_rows FROM customers  
UNION ALL
SELECT 'riders', COUNT(*) FROM riders     
UNION ALL
SELECT 'facilities', COUNT(*) FROM facilities 
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;

-- Primary Keys
ALTER TABLE customers  ADD CONSTRAINT PK_customers  PRIMARY KEY (customer_id);
ALTER TABLE riders     ADD CONSTRAINT PK_riders     PRIMARY KEY (rider_id);
ALTER TABLE facilities ADD CONSTRAINT PK_facilities PRIMARY KEY (facility_id);
ALTER TABLE orders     ADD CONSTRAINT PK_orders     PRIMARY KEY (order_id);

-- Foreign Keys
ALTER TABLE orders ADD CONSTRAINT FK_orders_customers  
    FOREIGN KEY (customer_id)  REFERENCES customers(customer_id);

ALTER TABLE orders ADD CONSTRAINT FK_orders_riders     
    FOREIGN KEY (rider_id)     REFERENCES riders(rider_id);

ALTER TABLE orders ADD CONSTRAINT FK_orders_facilities 
    FOREIGN KEY (facility_id)  REFERENCES facilities(facility_id);

SELECT TOP 10 * FROM orders
SELECT TOP 10 * FROM customers
SELECT TOP 10 * FROM riders
SELECT TOP 10 * FROM facilities


--PROBLEM STATEMENTS

--How many total orders were placed and what is the total revenue generated?
Select
count(order_id) as total_orders,
round(sum(final_amount),2) as total_revenue
From orders;

--How many orders were Completed, Cancelled and Delayed? Show count and percentage of each.
Select
status,
count(order_id) as order_count,
CONCAT(CAST(ROUND((COUNT(order_id) * 100.0) / (SELECT COUNT(*) FROM orders), 1) AS DECIMAL(5,1)), '%') AS percentage
from orders
group by status;

--Which service type is the most popular by number of orders?
Select top 1
service_type,
count(order_id) as order_count
From orders
group by service_type
order by order_count desc;

--List all customers from Koramangala — show their name, signup date and customer type.
Select
customer_name,
signup_date,
customer_type
From customers
where area='Koramangala';

--Which payment method is used the most?
Select top 1
payment_method,
count(order_id) as order_count
From orders
group by payment_method
order by order_count desc;

--Find the top 5 customers by total amount spent — show customer name, area and total spend.
Select top 5
c.customer_name,
c.area,
round(sum(final_amount),1) as total_spend
From customers as c
join orders as o
  on c.customer_id=o.customer_id
group by c.customer_name, c.area
order by total_spend desc;

--Which area in Bangalore generates the highest revenue?
Select top 1
area,
round(sum(final_amount),1) as highest_revenue
From customers as c
join orders as o
 on c.customer_id=o.customer_id
group by area
order by highest_revenue desc;

--Which rider has the highest average customer rating across all their deliveries?
Select top 1
r.rider_id,
r.rider_name,
round(avg(customer_rating),1) as avg_rating
From riders as r
join orders as o
on o.rider_id=r.rider_id
where o.status='Completed'
group by r.rider_id,r.rider_name
order by avg_rating desc;

--How many orders did each facility process? Which one is the busiest?
Select
f.facility_id,
f.facility_name,
count(order_id) as order_count
From facilities as f
join orders as o
 on f.facility_id=o.facility_id
where status<>'Cancelled'
group by f.facility_id, f.facility_name
order by order_count desc;

--Find all orders where a promo was used but customer rating is below 3.5
Select
order_id
from orders
where promo_used=1
and customer_rating<3.5
and status='Completed';

--Find customers who placed more than 5 orders — show their name and most recent order date.
Select
customer_name,
count(o.order_id) as order_count,
max(order_date) as recent_order_date
From customers as c
join orders as o
on o.customer_id=c.customer_id
group by customer_name
having count(order_id)>5
order by order_count desc;

-- For each service type, rank the top 3 riders by number of completed deliveries.
with ranking as(
Select
service_type,
rider_name,
Dense_rank() over(partition by service_type order by count(order_id) desc) as rank
From orders  as o
join riders as r
on o.rider_id=r.rider_id
where status='Completed'
group by service_type,rider_name
)
Select *
From ranking
where rank<4;

--Calculate the month-over-month revenue trend for 2024.
Select
month(order_date) as month,
round(sum(final_amount),0) as total_revenue
from orders 
where year(order_date)=2024
group by month(order_date)
order by month(order_date);

--Find the average delivery duration in hours per facility — only for completed orders.
Select
f.facility_id,
f.facility_name,
ROUND(AVG(DATEDIFF(minute,
        CONVERT(datetime, REPLACE(o.pickup_time, '.', ':'), 105),
        CONVERT(datetime, REPLACE(o.delivery_time, '.', ':'), 105)) / 60.0), 1) AS delivery_duration
from orders as o
join facilities as f
on o.facility_id=f.facility_id
where status='Completed'
group by f.facility_id, f.facility_name
order by delivery_duration;

--Identify churned customers — those whose last order was more than 6 months before Dec 2024 and never ordered again.
WITH cte1 as (
Select
c.customer_id,
customer_name,
max(order_date) as max_orderdate
from customers as c
join orders as o
on c.customer_id=o.customer_id
group by c.customer_id,customer_name
)
Select
customer_id,
customer_name
From cte1
where max_orderdate < '2024-06-30'
ORDER BY max_orderdate;

--For each customer find their first order and second order — show the gap in days between them.
with numbered as (
Select
c.customer_name,
o.order_date,
row_number() over (partition by c.customer_id order by o.order_date) as order_num
from customers as c
join orders as o
on c.customer_id = o.customer_id
),
first_second as (
Select
customer_name,
max(case when order_num = 1 then order_date end) as first_order,
max(case when order_num = 2 then order_date END) as second_order
from numbered
group by customer_name
)
Select
customer_name,
first_order,
second_order,
datediff(day, first_order, second_order) as gap_days
from first_second
where second_order is not null
order by gap_days;

--Find the busiest hour of the day for order placements — which hour gets the most orders?
Select top 1
left(order_time,2) as hours,
count(order_id) as order_count
From orders as o
group by left(order_time,2)
order by order_count desc;

-- Calculate the repeat order rate — what % of customers have placed more than 1 order?
with count_orders as(
Select 
customer_id
From orders 
group by customer_id
having count(order_id)>1
)
Select
(Select count(*) from count_orders) as repeat_customers,
(Select count(*) from customers) as total_customers,
concat(cast(round((Select count(*) from count_orders) * 100.0 / (Select count(*) from customers), 1)as decimal(5,1)), '%') as repeat_order_rate;

--Find facilities operating above 90% of their daily capacity on average — these are overloaded.
with total_per_day as (
Select
facility_id,
order_date,
count(order_id) as daily_orders
from orders
where status<>'Cancelled'
group by facility_id, order_date
),
avg_orders as (
Select
facility_id,
avg(daily_orders) as avg_daily_orders
From total_per_day
group by facility_id
)
SELECT
    f.facility_id,
    f.facility_name,           
    f.capacity_per_day,        
    a.avg_daily_orders        
FROM avg_orders AS a
JOIN facilities AS f           
    ON a.facility_id = f.facility_id
WHERE a.avg_daily_orders > f.capacity_per_day * 0.9;

--For each month in 2024, find the single highest revenue generating service type.
with sum_total as (
Select
month(order_date) as month,
service_type,
sum(final_amount) as total,
rank() over(partition by month(order_date) order by sum(final_amount) desc) as ranking
From orders 
where year(order_date)=2024
group by month(order_date),service_type
)
Select
month,
service_type
from sum_total
where ranking=1;

--Find riders who have delivered across the most number of different areas — show top 5.
Select top 5
rider_id,
count(distinct area) as area_count
From orders as o
join customers as c
 on o.customer_id=c.customer_id
group by rider_id
order by area_count desc;

-- Build a customer RFM summary — for each customer show:
--Recency → days since last order
--Frequency → total number of orders
--Monetary → total amount spent
Select
customer_name,
DATEDIFF(day,max(order_date),'2024-12-30') as recency_days,
count(order_id) as frequency,
round(sum(final_amount),2) as monetory
From orders as o
join customers as c
on c.customer_id=o.customer_id
group by c.customer_id,customer_name
order by recency_days desc;

--Find the average order value per service type — order from highest to lowest.
Select
service_type,
round(avg(final_amount),2) as order_value
From orders
group by service_type
order by order_value desc;

--Find customers where discount was given but revenue was still high — specifically promo used = 1 but final amount above average order value.
Select
c.customer_id,
c.customer_name,
round(sum(final_amount),2) as revenue,
(Select round(avg(final_amount),2) from orders) as avg_revenue
From orders as o
join customers as c
on o.customer_id=c.customer_id
where discount_pct>0
group by c.customer_id,c.customer_name
having sum(final_amount)>(Select avg(final_amount) from orders)
order by revenue desc;

--Find the top 3 facilities by average customer rating — only for completed orders
Select top 3
f.facility_id,
f.facility_name,
round(avg(customer_rating),1) as rating
from orders as o
join facilities as f
on o.facility_id=f.facility_id
where status='Completed'
group by f.facility_id, f.facility_name
order by avg(customer_rating) desc;