--Sales
SELECT 
    o.order_id, o.date, o.time, 
    d.quantity, p.size, p.price, 
    t.name, t.category
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
JOIN pizzas p ON d.pizza_id = p.pizza_id
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id;

--Total revenue by pizza category
SELECT t.category, round(SUM(d.quantity * p.price),2) as Total_Revenue
FROM order_details d
JOIN pizzas p ON d.pizza_id = p.pizza_id
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY Total_Revenue DESC;

--Bestseller
SELECT 
    pt.name, 
    Round(SUM(od.quantity * p.price),2) AS Total_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY Total_Revenue DESC;

--Busiest Hours
SELECT 
    datepart(HOUR,time) AS Order_Hour, 
    COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY datepart(HOUR,time)
ORDER BY Total_Orders DESC;

--Size Preference
SELECT 
    size,
    ROUND(Revenue, 2) AS Total_Revenue,
    ROUND(Revenue * 100 / SUM(Revenue) OVER(), 2) AS Percentage_Contribution
FROM (
    SELECT p.size, SUM(od.quantity * p.price) AS Revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY p.size
) AS Size_Sales
ORDER BY Percentage_Contribution DESC;