--Easy level--
--Show the category_name and description from the categories table sorted by category_name.--
SELECT category_name, description FROM categories
ORDER BY category_name

--Show all the contact_name, address, city of all customers which are not from 'Germany', 'Mexico', 'Spain'
SELECT contact_name, address, city FROM customers
WHERE country NOT IN ('Germany', 'Mexico', 'Spain')

--Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26--
SELECT order_date, shipped_date, customer_id, freight FROM orders
WHERE order_date = '2018-02-26'

--Show the company_name, contact_name, fax number of all customers that has a fax number--
SELECT company_name, contact_name, fax FROM customers
WHERE fax IS NOT NULL

--Show the first_name, last_name. hire_date of the most recently hired employee.--
SELECT first_name, last_name, hire_date FROM employees
ORDER BY hire_date DESC
LIMIT 1

--Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.--
SELECT ROUND((AVG(unit_price)), 2), SUM(units_in_stock), SUM(discontinued) FROM products

--Medium level--
--Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table--
SELECT product_name, company_name, category_name FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN suppliers s ON s.supplier_id = p.supplier_id

--Show the category_name and the average product unit price for each category rounded to 2 decimal places.--
SELECT category_name, ROUND(AVG(unit_price),2) AS average_unit_price FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY category_name

--Show the city, company_name, contact_name from the customers and suppliers table merged together. Create a column which contains 'customers' or 'suppliers' depending on the table it came from.--
SELECT city, company_name, contact_name, 'customers' AS role FROM customers 
UNION ALL
SELECT city, company_name, contact_name, 'suppliers' AS role FROM suppliers 
GROUP BY contact_name
ORDER BY city ASC

--Hard level--
--Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late.--
--Order by employee last_name, then by first_name, and then descending by number of orders.--
SELECT first_name, last_name, count(order_id),
CASE
  WHEN shipped_date <= required_date THEN 'On Time'
  WHEN shipped_date > required_date OR shipped_date IS NULL THEN 'Late'
END AS shipped
FROM employees e
JOIN orders o ON e.employee_id= o.employee_id
GROUP BY e.first_name, shipped
ORDER BY e.last_name, e.first_name, COUNT(order_id) DESC

--Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places--
SELECT YEAR(order_date) AS order_year, ROUND(SUM(p.unit_price * od.quantity * od.discount), 2) as discount_amount 
FROM orders o
JOIN order_details od ON o.order_id=od.order_id
JOIN products p ON od.product_id=p.product_id
GROUP BY order_year 
ORDER BY order_year DESC
