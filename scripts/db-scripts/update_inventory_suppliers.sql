DROP TRIGGER IF EXISTS UpdateInventorySuppliers;
GO

CREATE TRIGGER UpdateInventorySuppliers
ON Delivery
AFTER INSERT
AS
BEGIN
	INSERT INTO Inventory(product_id,stock_in,update_date)
	SELECT
		ins.product_id,
		ins.delivery_quantity,
		GETDATE()
	FROM
		inserted ins;
END;