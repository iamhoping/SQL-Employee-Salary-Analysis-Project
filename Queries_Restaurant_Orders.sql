
-- objective 1 - explore the items table

-- 1. view menu_items table.

select * from menu_items;

-- 2. find the number of items on the menu.

select count(*) from menu_items;


-- 3. What are the least and most expensive items on the menu?

select menu_item_id,item_name,category,max(price) over (partition by item_name) as price_list
from menu_items
order by price desc;

-- 4. How many Italian dishes are on the menu?

select count(*) from menu_items
where category = 'Italian';

-- 5. What are the least and most expensive italian dishes on the menu?

select menu_item_id,item_name,category,max(price) over () as price_list
from menu_items
where category = 'Italian'
order by price desc;

-- 6. How many dishes are in each category?
select category, count(menu_item_id) from menu_items
group by category;

-- 7. What is the average dish price within each category?

select category, avg(price) from menu_items
group by category;

-- objective 2 explore the order table

-- 1. view order_details table
select * from order_details;

-- 2. What is the range of the table?
select min(order_Date) , max(order_date) from order_details;

-- 3. How many others were made within this date range
select count(distinct order_date) from order_details;

-- 4. How many items were ordered within this date range?
select count(*) from order_details;

-- 5. Which orders had the most number of items?
select order_id ,count(item_id) num_items from order_details
group by order_id
order by num_items desc;

-- 6. How many orders had more than 12 items?
select order_id ,count(item_id) num_items from order_details
group by order_id
having num_items > 12
order by num_items;


-- objective 3 Analyze customer behavior

-- 1. Combine the menu_items and order_items tables into a single table.

select * from order_details d left join menu_items i  on i.menu_item_id = d.item_id;

-- 2. What were the least and most ordered items? What categories were they in?

select item_name,category, count(order_details_id) order_id 
from order_details d left join menu_items i  
	on i.menu_item_id = d.item_id
group by item_name, category
order by order_id desc;


-- 3. What are the top 5 orders that spent the most money?
select order_id,sum(price) as most_spent
from order_details d left join menu_items i  
	on i.menu_item_id = d.item_id
group by order_id
order by most_spent desc limit 5;

-- 4. View the details of the highest spend order. What insights can you gather from the table
select category,count(item_id) as num_items
from order_details d left join menu_items i  
	on i.menu_item_id = d.item_id
where order_id = 440
group by category;

-- 5. View the details of the top 5 highest spend orders. what insight can you gather from the table?

select order_id,category,count(item_id) as num_items
from order_details d left join menu_items i  
	on i.menu_item_id = d.item_id
where order_id in (440,2075,1957,330,2675)
group by order_id,category;

-- insight is the top 5 customers are spending a lot on italian foods