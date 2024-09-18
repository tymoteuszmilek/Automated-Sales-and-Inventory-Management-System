CREATE TRIGGER UpdateProductsSales
ON Sales
AFTER INSERT
AS
BEGIN
	-- Update the stock level of products based on the inserted sales
	UPDATE Products
	SET stock_level = stock_level - ins.quantity
	FROM Products p
	INNER JOIN inserted ins ON p.product_id = ins.product_id
END;
