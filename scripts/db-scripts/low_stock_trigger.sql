DROP TRIGGER IF EXISTS LowStockTrigger;
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
			stock_level < 10
	END
END;