/*
================================================================
Stored procedures : Load Silver layer ( source > silver)
================================================================
script purpose:
    This stored procedure performs the ETL (Extract,transform,load)
    to populate silver schema tables from the bronze schema
    It performes the following actions.
    - Truncates the silver table before loading data
    - insert transformed and cleansed data from bronze into
      silver tables.

Parameters:
    This stored procedure does not accept any parameter or return
    any value.
=================================================================
*/

create or alter procedure silver.load_silver as
Begin
	declare @start_time datetime, @end_time datetime;
	print '=============================';
	print 'Loading Silver layer';
	print '=============================';

	print '-----------------------------';
	print 'Loading Crm tables';
	print '-----------------------------';

	set @start_time = getdate();
	print '>> Truncating Table : silver.crm_cust_info';
	truncate table silver.crm_cust_info;

	print '>> inserting data into silver.silver.crm_cust_info';
	insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)

	select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status)) = 'S' then 'Single'
		 when upper(trim(cst_marital_status)) = 'M' then 'Married'
		 else 'Unkown'
	end
	cst_marital_status,
	case when upper(trim(cst_gndr)) = 'F' then 'Female'
		 when upper(trim(cst_gndr)) = 'M' then 'Male'
		 else 'Unkown'
	end cst_gndr,
	cst_create_date
	from
	(select *,
	ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_date
	from bronze.crm_cust_info
	where cst_id is not null) t
	where flag_date = 1;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> Truncating Table : silver.crm_prd_info';
	truncate table silver.crm_prd_info;

	print '>> inserting data into silver.crm_prd_info';
	insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt 
	)
	select 
	prd_id,
	replace(substring(prd_key,1,5), '-','_') as cat_id ,
	SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost, 0) as prd_cost,
	case when upper(trim(prd_line)) = 'M' then 'Mountain'
		 when upper(trim(prd_line)) = 'R' then 'Road'
		 when upper(trim(prd_line)) = 'S' then 'Other sales'
		 when upper(trim(prd_line)) = 'T' then 'Touring'
		 else 'N/A'
	end as prd_line,
	prd_start_dt,
	dateadd(day,-1,lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt
	from bronze.prd_info;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> Truncating Table : silver.crm_sales_details';
	truncate table silver.crm_sales_details;

	print '>> inserting data into silver.crm_sales_details';
	insert into silver.crm_sales_details(
	sls_ord_num, 
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)

	select 
	sls_ord_num, 
	sls_prd_key,
	sls_cust_id,
	case when sls_order_dt <=0 or len(sls_order_dt) != 8 then null
		 else cast(cast(sls_order_dt as varchar) as date)
	end as sls_order_dt,
	case when sls_ship_dt <=0 or len(sls_ship_dt) != 8 then null
		 else cast(cast(sls_ship_dt as varchar) as date)
	end as sls_ship_dt,
	case when sls_due_dt <=0 or len(sls_due_dt) != 8 then null
		 else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales
	end as sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price <= 0 
		then sls_sales/nullif(sls_quantity,0)
		else sls_price
	end as sls_price
	from bronze.sales_details;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

		--Data load in erp tables -- 

	set @start_time = getdate();
	print '>> Truncating Table : silver.erp_cust_azw';
	truncate table silver.erp_cust_azw;

	print '>> inserting data into silver.erp_cust_azw';
	insert into silver.erp_cust_azw(CID,BDATE,GEN)
	select 
	case when CID like 'NAS%' then SUBSTRING(CID,4,LEN(CID))
		 else CID
	end as CID,
	case when BDATE > getdate() then null
		 else BDATE
	end as BDATE,
	case when upper(trim(gen)) in ('M', 'MALE') THEN 'Male'
		 when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
		 else 'n/a'
	end as Gen
	from bronze.erp_cust_azw;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> Truncating Table :silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;

	print '>> inserting data into silver.erp_loc_a101';
	INSERT INTO silver.erp_loc_a101(CID,CNTRY)
	select
	replace(CID,'-','') as CID,
	case when trim(CNTRY) = 'DE' THEN 'Germany'
		 when trim(CNTRY) IN ( 'US','USA') THEN 'United States'
		 WHEN trim(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
		 else trim(CNTRY)
	END AS CNTRY
	from bronze.erp_loc;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';

	set @start_time = getdate();
	print '>> Truncating Table : silver.erp_px_cat_g1';
	truncate table silver.erp_px_cat_g1;

	print '>> inserting data into silver.erp_px_cat_g1';
	insert into silver.erp_px_cat_g1(
	id,
	cat,
	subcat,
	maintenance)
	select
	id,
	cat,
	subcat,
	maintenance
	from bronze.erp_px_cat_g1;
	set @end_time = getdate();
	print '>> Load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
	print '-------------------------';
end

EXEC silver.load_silver;
