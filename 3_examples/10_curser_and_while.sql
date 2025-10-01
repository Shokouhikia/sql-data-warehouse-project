DECLARE @order_number NVARCHAR(50);
DECLARE @sales_amount DECIMAL(18,2);

DECLARE sales_cursor CURSOR FOR
SELECT order_number, sales_amount
FROM DataWarehouse.gold.fact_sales;

OPEN sales_cursor;

FETCH NEXT FROM sales_cursor INTO @order_number, @sales_amount;

WHILE @@FETCH_STATUS = 0
BEGIN

    IF @sales_amount > 1000
        PRINT 'Order ' + @order_number + ' gets a discount ' + CAST(@sales_amount AS NVARCHAR(20));
    ELSE
        PRINT 'Order ' + @order_number + ' does not get a discount ' + CAST(@sales_amount AS NVARCHAR(20));

    FETCH NEXT FROM sales_cursor INTO @order_number, @sales_amount;
END

CLOSE sales_cursor;
DEALLOCATE sales_cursor;
