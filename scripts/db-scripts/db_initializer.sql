-- Drop the existing database if it exists
DROP DATABASE IF EXISTS Sales_and_Inventory_Managment_System;
GO

-- Create a new database
CREATE DATABASE Sales_and_Inventory_Managment_System;
GO

-- Switch to the new database context
USE Sales_and_Inventory_Managment_System;
GO

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

-- Drop existing triggers and procedures
DROP TRIGGER IF EXISTS UpdateInventorySales;
DROP TRIGGER IF EXISTS trg_AfterInsertSales;
DROP TRIGGER IF EXISTS LowStockTrigger;
DROP TRIGGER IF EXISTS UpdateProductsDelivery;
DROP PROCEDURE IF EXISTS CreateOrder;
DROP PROCEDURE IF EXISTS CreateReorderForLowStockProducts;
DROP PROCEDURE IF EXISTS GenerateWeeklySalesReport;
GO

-- Create triggers
CREATE TRIGGER UpdateInventorySales
ON Sales
AFTER INSERT
AS
BEGIN
    INSERT INTO Inventory(product_id, stock_out, update_date)
    SELECT
        ins.product_id,
        ins.quantity,
        GETDATE()
    FROM
        inserted ins;
END;
GO

CREATE TRIGGER trg_AfterInsertSales
ON Sales
AFTER INSERT
AS
BEGIN
    INSERT INTO Invoices (sale_id, subtotal, discount, tax_amount, total_amount, invoice_date)
    SELECT 
        i.sale_id, 
        (s.quantity * p.price) AS subtotal,
        (s.quantity * p.price) * 0.10 AS discount, 
        ((s.quantity * p.price) - (s.quantity * p.price) * 0.10) * 0.15 AS tax_amount,
        ((s.quantity * p.price) - (s.quantity * p.price) * 0.10) + 
        (((s.quantity * p.price) - (s.quantity * p.price) * 0.10) * 0.15) AS total_amount,
        GETDATE() AS invoice_date
    FROM 
        inserted i
    JOIN 
        Sales s ON i.sale_id = s.sale_id
    JOIN 
        Products p ON s.product_id = p.product_id;
END;
GO

CREATE TRIGGER LowStockTrigger
ON Products
AFTER UPDATE
AS 
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE stock_level < 10) -- 10 is the threshold
    BEGIN
        SELECT
            product_id,
            product_name,
            stock_level
        FROM
            Products
        WHERE
            stock_level < 10;
    END
END;
GO

CREATE TRIGGER UpdateProductsSales
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE Products
    SET stock_level = stock_level - ins.quantity
    FROM Products p
    INNER JOIN inserted ins ON p.product_id = ins.product_id;
END;
GO

CREATE TRIGGER UpdateProductsDelivery
ON Delivery
AFTER INSERT
AS
BEGIN
    UPDATE Products
    SET stock_level = stock_level + ins.delivery_quantity
    FROM Products p
    INNER JOIN inserted ins ON p.product_id = ins.product_id;
END;
GO

-- Create stored procedures
CREATE PROCEDURE CreateOrder
    @product_id INT,
    @quantity INT = 20
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE product_id = @product_id)
    BEGIN
        INSERT INTO Delivery (supplier_id, product_id, delivery_quantity, delivery_date)
        SELECT
            s.supplier_id,
            p.product_id,
            @quantity,
            GETDATE()
        FROM
            Products p
        JOIN
            Suppliers s ON p.supplier_id = s.supplier_id
        WHERE
            p.product_id = @product_id;
    END
    ELSE
    BEGIN
        PRINT CONCAT('Product with ID of ', @product_id, ' does not exist.');
    END
END;
GO

CREATE PROCEDURE CreateReorderForLowStockProducts
AS
BEGIN
    SELECT 
        p.product_id, 
        p.product_name, 
        p.stock_level, 
        CONCAT(s.supplier_first_name, ' ', s.supplier_last_name) AS supplier_full_name,
        s.supplier_company_name AS company_name,
        CONCAT(s.supplier_email, ' ', s.supplier_phone_number) AS contact_details
    FROM
        Products p
    JOIN
        Suppliers s ON p.supplier_id = s.supplier_id
    WHERE
        p.stock_level < 10;

    INSERT INTO Delivery (supplier_id, product_id, delivery_quantity, delivery_date)
    SELECT
        p.supplier_id,
        p.product_id,
        30, -- assuming we order 30 units
        GETDATE()
    FROM
        Products p
    WHERE
        p.stock_level < 10;
END;
GO

CREATE PROCEDURE GenerateWeeklySalesReport
AS
BEGIN
    DECLARE
        @columns NVARCHAR(MAX) = '',
        @sql NVARCHAR(MAX) = '';

    -- Select product_id's for pivot
    SELECT
        @columns += QUOTENAME(p.product_name) + ','
    FROM
        Sales s
    JOIN
        Products p ON s.product_id = p.product_id
    WHERE
        sale_date >= DATEADD(day, -6, CAST(GETDATE() AS DATE))
    GROUP BY
        p.product_name
    ORDER BY
        p.product_name;

    -- Remove the last comma from @columns
    SET @columns = LEFT(@columns, LEN(@columns) - 1);

    -- Construct dynamic SQL for pivot table
    SET @sql = '
    SELECT 
        sale_date, ' + @columns + '
    FROM
    (
        SELECT 
            product_name,
            CAST(sale_date AS DATE) as sale_date,
            quantity * price AS total_amount
        FROM
            Sales s
        JOIN
            Products p ON s.product_id = p.product_id
        WHERE
            s.sale_date >= DATEADD(day, -6, CAST(GETDATE() AS DATE))
    ) AS SourceTable
    PIVOT
    (
        SUM(total_amount)
        FOR product_name IN (' + @columns + ')
    ) AS PivotTable';

    -- Execute dynamic SQL
    EXECUTE sp_executesql @sql;
END;
GO
