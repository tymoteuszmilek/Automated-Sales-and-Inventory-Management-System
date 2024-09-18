BEGIN TRANSACTION;

-- Delete from all tables (assuming foreign key constraints are managed properly)
DELETE FROM Delivery;
DELETE FROM Invoices;
DELETE FROM Sales;
DELETE FROM Inventory;
DELETE FROM Products;
DELETE FROM Customers;
DELETE FROM Suppliers;

-- Insert into Suppliers (IDs corrected)
INSERT INTO Suppliers (supplier_id, supplier_first_name, supplier_last_name, supplier_company_name, supplier_email, supplier_phone_number)
VALUES 
(1, 'John', 'Doe', 'Tech Supplies Co.', 'john.doe@techsupplies.com', '555-1234'),
(2, 'Jane', 'Smith', 'Gadget World', 'jane.smith@gadgetworld.com', '555-5678'),
(3, 'Emily', 'Jones', 'ElectroMart', 'emily.jones@electromart.com', '555-8765'),
(4, 'Michael', 'Brown', 'Future Tech', 'michael.brown@futuretech.com', '555-4321'),
(5, 'Linda', 'Williams', 'Smart Solutions', NULL, '555-1111'),
(6, 'Sophia', 'Davis', 'Electronics Plus', NULL, '555-2222'),
(7, 'William', 'Miller', 'High-Tech Systems', NULL, '555-3333'),
(8, 'Olivia', 'Wilson', 'NextGen Devices', 'olivia.wilson@nextgendevices.com', '555-4444'),
(9, 'James', 'Taylor', 'Advanced Electronics', 'james.taylor@advancedelectronics.com', '555-5555');

-- Insert into Products (IDs corrected)
INSERT INTO Products (product_id, product_name, price, stock_level, supplier_id)
VALUES 
(1, 'Smartphone', 299.99, 50, 1),  
(2, 'Laptop', 799.99, 30, 2),      
(3, 'Bluetooth Speaker', 99.99, 100, 3), 
(4, 'Headphones', 149.99, 70, 1), 
(5, 'Tablet', 349.99, 20, 4),     
(6, 'Smartwatch', 199.99, 60, 5), 
(7, 'Monitor', 199.99, 40, 6),   
(8, 'Printer', 129.99, 25, 7),  
(9, 'Webcam', 89.99, 80, 8),    
(10, 'Router', 69.99, 120, 9);

-- Insert into Customers (IDs corrected)
INSERT INTO Customers (customer_id, customer_first_name, customer_last_name, customer_email, customer_phone_number)
VALUES 
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', '555-1111'),
(2, 'Bob', 'Williams', 'bob.williams@example.com', '555-2222'),
(3, 'Charlie', 'Brown', 'charlie.brown@example.com', '555-3333'),
(4, 'David', 'Smith', 'david.smith@example.com', '555-4444'),
(5, 'Eva', 'Davis', 'eva.davis@example.com', '555-5555'),
(6, 'Frank', 'Wilson', 'frank.wilson@example.com', '555-6666'),
(7, 'Grace', 'Taylor', 'grace.taylor@example.com', '555-7777'),
(8, 'Hannah', 'Moore', 'hannah.moore@example.com', '555-8888'),
(9, 'Isaac', 'Lee', 'isaac.lee@example.com', '555-9999'),
(10, 'Jessica', 'Martinez', 'jessica.martinez@example.com', '555-0000'),
(11, 'Kevin', 'Anderson', 'kevin.anderson@example.com', '555-1212'),
(12, 'Laura', 'Thomas', 'laura.thomas@example.com', '555-1313'),
(13, 'Michael', 'Jackson', 'michael.jackson@example.com', '555-1414'),
(14, 'Nina', 'White', 'nina.white@example.com', '555-1515'),
(15, 'Oliver', 'Harris', 'oliver.harris@example.com', '555-1616'),
(16, 'Paula', 'Clark', 'paula.clark@example.com', '555-1717'),
(17, 'Quincy', 'Lewis', 'quincy.lewis@example.com', '555-1818'),
(18, 'Rachel', 'Walker', 'rachel.walker@example.com', '555-1919'),
(19, 'Samuel', 'Hall', 'samuel.hall@example.com', '555-2020'),
(20, 'Tina', 'Allen', 'tina.allen@example.com', '555-2121'),
(21, 'Ursula', 'Young', 'ursula.young@example.com', '555-2222');

-- Insert into Sales (customer_id and product_id corrected)
INSERT INTO Sales (customer_id, product_id, quantity, sale_date)
VALUES 
(1, 1, 2, '2024-09-15'),
(2, 3, 1, '2024-09-16'),
(3, 2, 5, '2024-09-16'),
(1, 4, 3, '2024-09-17'),
(2, 5, 4, '2024-09-18'),
(4, 1, 1, '2024-09-18'),
(5, 2, 2, '2024-09-19'),
(6, 3, 3, '2024-09-20'),
(7, 4, 1, '2024-09-21'),
(8, 5, 2, '2024-09-22'),
(9, 1, 5, '2024-09-23'),
(10, 2, 3, '2024-09-24'),
(11, 3, 2, '2024-09-25'),
(12, 4, 4, '2024-09-26'),
(13, 5, 1, '2024-09-27'),
(14, 1, 2, '2024-09-28'),
(15, 2, 5, '2024-09-29'),
(16, 3, 1, '2024-09-30'),
(17, 4, 3, '2024-10-01'),
(18, 5, 2, '2024-10-02'),
(19, 1, 4, '2024-10-03'),
(20, 2, 1, '2024-10-04'),
(21, 3, 3, '2024-10-05');

COMMIT TRANSACTION;
