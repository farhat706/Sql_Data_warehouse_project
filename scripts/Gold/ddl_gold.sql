/*
=====================================================
DDL script : Create silver tables
=====================================================
script purpose:
        This script creates views for the gold
        layer in the data warehouse.
        The gold layer represents the final dimension
        and fact table (star schema).

        Each view performs transformation and combine
        data from silver layer to produce clean,
        enriched and business ready dataset
======================================================
*/
---Develop SQL Load Scripts---

--Gold.dim_customers--  
create view Gold.dim_customers as
select 
	ROW_NUMBER() over(order by cst_id) as customer_key, -- created surrogated key --
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr != 'unkown' then ci.cst_gndr -- CRM is the master for gender info
	else coalesce( ca.gen, 'n/a')
    end as gender,
	ca.BDATE as birthdate,
	la.cntry as country
from silver.crm_cust_info as ci
left join silver.erp_cust_azw ca
on   ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on	 ci.cst_key = la.cid; 

--Gold.dim_products--
create view Gold.dim_products as
select
	ROW_NUMBER() over(order by pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt	as start_date
from silver.crm_prd_info as pn
left join silver.erp_px_cat_g1 as pc;

--Gold.fact_sales--
create view Gold.fact_sales as
select 
	sd.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details sd
left join Gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join Gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id;
