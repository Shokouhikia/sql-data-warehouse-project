--create new ctas for testing partitions

IF OBJECT_ID('silver.ctas_crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.ctas_crm_sales_details;
GO
select *
into silver.ctas_crm_sales_details
from silver.crm_sales_details


select distinct(year(sales.sls_order_Dt)) years
from silver.ctas_crm_sales_details sales
order by years
--result:
/*
		NULL
		2010
		2011
		2012
		2013
		2014
*/
--drop partition function partition_by_year
create partition function partition_by_year (date)
    as range left for values ('2010-12-31','2011-12-31','2012-12-31','2013-12-31')


-- listing all partitions
select name
     , function_id
     , type
     , type_desc
     , boundary_value_on_right
from sys.partition_functions


--create file group

alter Database datawarehouse add filegroup FG_2010;
alter Database datawarehouse add filegroup FG_2011;
alter Database datawarehouse add filegroup FG_2012;
alter Database datawarehouse add filegroup FG_2013;
alter Database datawarehouse add filegroup FG_2014;


select *
from sys.filegroups
where type = 'FG'


alter Database datawarehouse add file
    (
        name = P_2010,
        filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2010.ndf'
        ) to filegroup FG_2010
alter Database datawarehouse add file
    (
        name = P_2011,
        filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2011.ndf'
        ) to filegroup FG_2011
alter Database datawarehouse add file
    (
        name = P_2012,
        filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2012.ndf'
        ) to filegroup FG_2012
alter Database datawarehouse add file
    (
        name = P_2013,
        filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2013.ndf'
        ) to filegroup FG_2013
alter Database datawarehouse add file
    (
        name = P_2014,
        filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\P_2014.ndf'
        ) to filegroup FG_2014


create partition scheme schema_partition_by_year
    as partition partition_by_year
    to (FG_2010,
    FG_2011,
    FG_2012,
    FG_2013,
    FG_2014)


drop TABLE silver.ctas_partitioning_sales
CREATE TABLE silver.ctas_partitioning_sales
(
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_order_dt_FA DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)
    ON schema_partition_by_year
(
    sls_order_dt
);



INSERT INTO silver.ctas_partitioning_sales
SELECT *
FROM silver.crm_sales_details;


SELECT *
FROM silver.ctas_partitioning_sales;

SELECT p.partition_number AS PartitionNumber,
       f.name             AS PartitionFilegroup,
       p.rows             AS NumberOfRows
FROM sys.partitions p
         JOIN sys.destination_data_spaces dds
              ON p.partition_number = dds.destination_id
         JOIN sys.filegroups f
              ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'ctas_partitioning_sales';

--1	FG_2010	33
--2	FG_2011	2216
--3	FG_2012	3397
--4	FG_2013	52782
--5	FG_2014	1970