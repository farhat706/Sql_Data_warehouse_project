/*
================================================================
Stored procedures : Load bronze layer ( source > bronze)
================================================================
script purpose:
    This stored procedure loads data into bronze
    schema from external csv files.
    It performes the following actions.
    - Truncates the bronze table before loading data
    - uses 'bulk insert' command to load data into bronze tables

Parameters:
    This stored procedure does not accept any parameter or return
    any value.
=================================================================
*/

---Develop SQL Load Scripts---

--sales table--

create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime;
	print '=============================';
	print 'Loading bronze layer';
	print '=============================';

	print '-----------------------------';
	print 'Loading Crm tables';
	print '-----------------------------';

	set @start_time = getdate();
	print '>> truncating table :bronze.crm_cust_info';
	truncate table bronze.crm_cust_info;

	print '>> Inserting data :bronze.crm_cust_info';
	bulk insert bronze.crm_cust_info
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_crm\cust_info.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> truncating table :bronze.prd_info';
	truncate table bronze.prd_info;

	print '>> Inserting data :bronze.prd_info';
	bulk insert bronze.prd_info
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_crm\prd_info.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';


	set @start_time = getdate();
	print '>> truncating table :bronze.sales_details';
	truncate table bronze.sales_details;

	print '>> Inserting data :bronze.sales_details';
	bulk insert bronze.sales_details
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_crm\sales_details.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';


	--Data load in erp tables -- 
	print '-----------------------------';
	print 'Loading ERP tables';
	print '-----------------------------';

	set @start_time = getdate();
	print '>> truncating table :bronze.erp_cust_azw';
	truncate table bronze.erp_cust_azw;

	print '>> Inserting data :bronze.erp_cust_azw';
	bulk insert bronze.erp_cust_azw
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_erp\CUST_AZ12.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> truncating table :bronze.erp_loc';
	truncate table bronze.erp_loc;

	
	print '>> Inserting data :bronze.erp_loc';
	bulk insert bronze.erp_loc
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_erp\LOC_A101.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> truncating table :bronze.erp_px_cat_g1';
	truncate table bronze.erp_px_cat_g1;

	print '>> Inserting data :bronze.erp_px_cat_g1';
	bulk insert bronze.erp_px_cat_g1
	from 'E:\farhat\Data analytics\Sql\Datawarehouse_project\source_erp\PX_CAT_G1V2.csv'
	with(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
);
set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';
end
