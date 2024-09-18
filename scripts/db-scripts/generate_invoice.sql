CREATE TRIGGER trg_AfterInsertSales
ON Sales
AFTER INSERT
AS
BEGIN
    -- Insert new invoices for every row inserted in the Sales table
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
