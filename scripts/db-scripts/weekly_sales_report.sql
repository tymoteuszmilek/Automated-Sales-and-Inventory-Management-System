DROP PROCEDURE IF EXISTS GenerateWeeklySalesReport
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
    	Products p
    ON
    	s.product_id = p.product_id
    WHERE
        sale_date >= DATEADD(day, -6, CAST(GETDATE() AS DATE))
    GROUP BY
    	p.product_name
    ORDER BY
    	p.product_name

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
            Products p
        ON
            s.product_id = p.product_id
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
