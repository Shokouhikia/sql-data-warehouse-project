select *
into silver.sales_index_table
from silver.crm_sales_details

select *
from silver.sales_index_table

create clustered index idx_siversales_slscustid
    on silver.sales_index_table (sls_cust_id)


create nonclustered index idx_siversales_sls_ord_num
    on silver.sales_index_table (sls_ord_num)


create nonclustered index idx_silversales_dateFromTO
    on silver.sales_index_table (sls_ship_dt, sls_due_dt)
--test

select *
from silver.sales_index_table
where YEAR(sls_ship_dt) > '2013'
  and YEAR(sls_due_dt) > '2012' 