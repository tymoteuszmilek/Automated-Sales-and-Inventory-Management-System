DROP PROCEDURE IF EXISTS CreateReorderForLowStockProducts;
GO

CREATE PROCEDURE CreateReorderForLowStockProducts
AS
BEGIN
    -- Generate the reorder list
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

    -- Insert reorder requests into Delivery table
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

END
GO
