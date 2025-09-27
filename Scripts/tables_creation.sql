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
