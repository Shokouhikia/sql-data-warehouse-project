/*
if OBJECT_ID('bronze.customer_logs', 'U') is not null
    drop table bronze.customer_logs
create table bronze.customer_logs
(
    customer_id int,
    first_name  nvarchar(50),
    last_name   nvarchar(50),
    log_date    date
)
*/
create trigger trg_after_insert_cutomers
    on bronze.crm_cust_info
    after insert
	as
begin
    insert into bronze.customer_logs(customer_id,
                                     first_name,
                                     last_name,
                                     log_date)
    select cst_id as customer_id, cst_firstname as first_name, cst_lastname as last_name, getdate() as log_date 
    from INSERTED
end


--insert into bronze.crm_cust_info values (918913258,'12332','first','last','12332',null,null)


--select * from bronze.customer_logs