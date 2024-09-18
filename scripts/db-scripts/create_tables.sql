BEGIN TRANSACTION;

-- Drop tables in reverse order of their dependencies
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Suppliers;

-- Recreate tables
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_first_name NVARCHAR(100),
    supplier_last_name NVARCHAR(100),
    supplier_company_name NVARCHAR(100),
    supplier_email NVARCHAR(100),
    supplier_phone_number NVARCHAR(20) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(100),
    price DECIMAL(10,2),
    stock_level INT,
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    CHECK(stock_level >= 0)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_first_name NVARCHAR(100) NOT NULL,
    customer_last_name NVARCHAR(100) NOT NULL,
    customer_email NVARCHAR(100),
    customer_phone_number NVARCHAR(20)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(product_id) ON DELETE CASCADE,
    quantity INT,
    sale_date DATETIME
);

CREATE TABLE Inventory (
    product_id INT FOREIGN KEY REFERENCES Products(product_id) ON DELETE CASCADE,
    stock_in INT,
    stock_out INT,
    update_date DATETIME
);

CREATE TABLE Invoices (
    invoice_id INT PRIMARY KEY IDENTITY(1,1),
    sale_id INT FOREIGN KEY REFERENCES Sales(sale_id) ON DELETE CASCADE,
    subtotal DECIMAL(10,2),
    discount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    invoice_date DATETIME
);

CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY IDENTITY(1,1),
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(product_id) ON DELETE NO ACTION,
    delivery_quantity INT NOT NULL,
    delivery_date DATETIME DEFAULT GETDATE()
);


COMMIT TRANSACTION;
