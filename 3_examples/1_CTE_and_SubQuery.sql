with total_sales as (SELECT T.customer_key,
                            T.total_sales,
                            RANK() OVER (ORDER BY total_sales, customer_key DESC) CUSOMER_RANK
                     FROM (select sales.customer_key,
                                  sum(sales.sales_amount) as total_sales


                           from gold.fact_sales sales

                           group by sales.customer_key
                           having sum(sales.sales_amount) > 1000) T)
select customers.customer_id,
       customers.first_name,
       customers.last_name,
       total_sales.total_sales,
       total_sales.CUSOMER_RANK
from gold.dim_customers customers
         inner join total_sales on total_sales.customer_key = customers.customer_key


