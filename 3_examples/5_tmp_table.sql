select *
into #tmp_customers
from gold.dim_customers;

select *
from #tmp_customers;