DROP TRIGGER IF EXISTS UpdateInventorySales;
GO 

CREATE TRIGGER UpdateInventorySales
ON Sales
AFTER INSERT
AS
BEGIN
	INSERT INTO Inventory(product_id,stock_out,update_date)
	SELECT
		ins.product_id,
		ins.quantity,
		GETDATE()
	FROM
		inserted ins;
END;
