DROP PROCEDURE IF EXISTS CreateOrder;
GO

CREATE PROCEDURE CreateOrder
    @product_id INT,
    @quantity INT = 20
AS
BEGIN
	-- Check if the product exists
	IF EXISTS (SELECT 1 FROM Products WHERE product_id = @product_id)
		BEGIN
    	-- Insert into Delivery table
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
        	PRINT CONCAT('Product with ID of ',@product_id,' does not exist.');
        END
END;
