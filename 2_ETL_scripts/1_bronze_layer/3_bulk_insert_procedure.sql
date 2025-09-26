Create or Alter Procedure bronze.load_bronze as
BEGIN

    declare @start_time datetime,@end_time datetime;
    set @start_time = GETDATE();
    begin try
        print ('TRUNCATING Bronze tables...')
        TRUNCATE TABLE bronze.crm_cust_info;
        TRUNCATE TABLE bronze.crm_sales_details;
        TRUNCATE TABLE bronze.crm_prd_info;
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        TRUNCATE TABLE bronze.erp_loc_a101;
        TRUNCATE TABLE bronze.erp_CUST_AZ12;


        print ('Bulk insert from Files...')
        bulk insert bronze.crm_cust_info
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_crm\cust_info.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock --imporving bulk insert performance
            );


        bulk insert bronze.crm_sales_details
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_crm\sales_details.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock
            );


        bulk insert bronze.crm_prd_info
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_crm\prd_info.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock
            );


        bulk insert bronze.erp_px_cat_g1v2
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_erp\PX_CAT_G1V2.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock
            );


        bulk insert bronze.erp_loc_a101
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_erp\LOC_A101.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock
            );


        bulk insert bronze.erp_CUST_AZ12
            from 'C:\Users\Shokouhikia\Desktop\sql-data-warehouse-project\1_datasets\source_erp\CUST_AZ12.csv'
            with (
            Firstrow =2,
            FIELDTERMINATOR =',',
            tablock
            );
    end try
    begin catch
        print ('something is wrong')
        print ('error_message ' + error_message())
        print ('error_number' + cast(error_number() as nvarchar))
        print ('error_state ' + cast(error_state() as nvarchar))
    end catch

    set @end_time = GETDATE();
    PRINT 'load duration: '
        + CAST(DATEDIFF(millisecond, @start_time, @end_time) / 1000.0 AS NVARCHAR(20))
        + ' seconds';
end
