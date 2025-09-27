create or alter procedure gold.update_ctas as
begin

    declare @start_time datetime, @end_time datetime;

    set @start_time = getdate();


    IF OBJECT_ID('gold.ctas_fact_sales_fa', 'U') IS NOT NULL
        DROP TABLE gold.ctas_fact_sales_fa;


    SELECT sd.sls_ord_num                                 AS order_number,
           pr.product_key                                 AS product_key,
           cu.customer_key                                AS customer_key,

           FORMAT(sd.sls_order_dt, 'yyyy/MM/dd', 'fa-IR') AS order_date_fa,
           FORMAT(sd.sls_ship_dt, 'yyyy/MM/dd', 'fa-IR')  AS shipping_date_fa,
           FORMAT(sd.sls_due_dt, 'yyyy/MM/dd', 'fa-IR')   AS due_date_fa,

           sd.sls_sales                                   AS sales_amount,
           sd.sls_quantity                                AS quantity,
           sd.sls_price                                   AS price
    INTO gold.ctas_fact_sales_fa
    FROM silver.crm_sales_details sd
             LEFT JOIN gold.dim_products pr
                       ON sd.sls_prd_key = pr.product_number
             LEFT JOIN gold.dim_customers cu
                       ON sd.sls_cust_id = cu.customer_id;

    set @end_time = getdate();
    print 'CTAS update duration: ' + cast(datediff(millisecond, @start_time, @end_time) / 1000.0 AS NVARCHAR(20))


end

