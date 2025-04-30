-- CREATING database for customers , produts , sales
CREATE DATABASE CUSTOMERS_DB;
USE CUSTOMERS_DB;




-- PRODUCTS_TABLE : Stores product details , whidh stores product_id , product_name , category_details & price-details
CREATE TABLE products_table (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_details VARCHAR(50),
    price_details DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

-- CUSTOMERS_TABLE : Stores customer details , like : customer_id , full_name , email_id &  region
CREATE TABLE customers_table(
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email_id VARCHAR(100) UNIQUE,
    region VARCHAR(50)
);

-- SALES_TABLE: Stores sales transaction records , like : sale_id , product_id , customer_id , quantity , sale_date & unit_price 
CREATE TABLE sales_table(
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    sale_date DATE NOT NULL,
    -- price is captured at the time of sale in case it changes later
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    -- Foreign keys to maintain integrity 
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- INDEXES to improve performance on frequent filters and joins effectiverly
CREATE INDEX idx_sale_date ON sales_table(sale_date);
CREATE INDEX idx_customer_region ON customers_table(region);
CREATE INDEX idx_product_category ON products_table(category_details);


-- Sample products details inserting
INSERT INTO products_table(product_name, category_details, price_details)
VALUES 
('Laptop', 'Electronics', 65000.00),
('Office Chair', 'Furniture', 5000.00),
('Wireless Mouse', 'Electronics', 1200.00);

-- Sample customers data inserting
INSERT INTO customers_table(full_name, email_id, region)
VALUES 
('Anjali Rao', 'anjali.rao@example.com', 'South'),
('Manish Verma', 'manish.verma@example.com', 'North');


-- sample sales data inserting
INSERT INTO sales_table(product_id, customer_id, quantity, sale_date, unit_price)
VALUES 
(1, 1, 2, '2025-04-01', 65000.00),
(2, 1, 1, '2025-04-02', 5000.00),
(3, 2, 3, '2025-04-03', 1200.00);



-- Analizing total sales revenue by category for each region in April-2025 
SELECT 
    c.region, 
    p.category_details,
    SUM(s.quantity * s.unit_price) AS total_revenue,
    COUNT(DISTINCT s.sale_id) AS total_orders
FROM sales_table AS s
JOIN products_table AS p ON s.product_id = p.product_id -- joining at product_id form each tables
JOIN customers_table AS c ON s.customer_id = c.customer_id -- which joins three columns form three tables
WHERE MONTH(s.sale_date) = 4 AND YEAR(s.sale_date) = 2025 -- condition for to return the data which returns in APRIL-2025
GROUP BY c.region, p.category_details  -- as mentioned , grouping rows by category in customer_table and region in product_table
ORDER BY total_revenue DESC; -- in decreading order by total_revenue
