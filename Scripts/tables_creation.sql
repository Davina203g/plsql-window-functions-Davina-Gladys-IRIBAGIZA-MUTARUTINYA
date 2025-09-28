--CUSTOMERS table creation query:
  
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
)

--PRODUCTS table creation query:

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMBER NOT NULL
)

--TRANSACTIONS TABLE creation query:

CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    sale_date DATE NOT NULL,
    quantity NUMBER NOT NULL,
    total_amount NUMBER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
)

--Insertion of some few data( Two examples per table)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, quantity, total_amount) VALUES (1021, 1, 107, DATE '2024-07-03', 1, 1500);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, quantity, total_amount) VALUES (1022, 2, 110, DATE '2024-07-10', 3, 1650);
INSERT INTO products (product_id, name, category, unit_price) VALUES (109, 'Guava', 'Fruits', 450);
INSERT INTO products (product_id, name, category, unit_price) VALUES (110, 'Papaya', 'Fruits', 550);
INSERT INTO customers (customer_id, name, region) VALUES (9, 'Peace', 'Huye');
INSERT INTO customers (customer_id, name, region) VALUES (8, 'Joseline', 'Muhanga');
