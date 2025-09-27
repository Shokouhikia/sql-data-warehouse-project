IF OBJECT_ID('gold.fact_sales_fa', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales_fa;
GO

CREATE VIEW gold.fact_sales_fa AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,

    FORMAT(sd.sls_order_dt, 'yyyy/MM/dd', 'fa-IR') AS order_date_fa,
    FORMAT(sd.sls_ship_dt, 'yyyy/MM/dd', 'fa-IR')  AS shipping_date_fa,
    FORMAT(sd.sls_due_dt,  'yyyy/MM/dd', 'fa-IR')  AS due_date_fa,

    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
