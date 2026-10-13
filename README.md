# SQL Data Warehouse Project | End-to-End ETL Pipeline
![Image Alt](https://github.com/farhat706/Sql_Data_warehouse_project/blob/ee8b67729451204c5a2ad0eb4a0823c21ca9d0ef/image%20(13).png)

## 📌 Project Overview

This project demonstrates the design and implementation of an end-to-end SQL data warehouse using **Microsoft SQL Server** and the **Medallion Architecture**. It integrates customer and product data from CRM and ERP source systems, processes the data through Bronze, Silver, and Gold layers, and prepares it for business intelligence, reporting, and analytical use cases.

The project follows a structured ETL workflow to improve data quality, consistency, and accessibility, transforming raw source data into business-ready datasets.

## 🏗️ Data Architecture

The data warehouse follows a three-layer Medallion Architecture:

**Source Systems → Bronze → Silver → Gold → Analytics & Reporting**

### 🥉 Bronze Layer — Raw Data

* Loads raw data from CRM and ERP source systems using CSV files.
* Stores data in its original form with minimal transformations.
* Supports both full-load and incremental-load strategies where applicable.
* Preserves source data for auditing and downstream processing.

### 🥈 Silver Layer — Cleansed & Standardized Data

* Cleans and validates raw data.
* Handles missing values, duplicates, and inconsistent records.
* Standardizes data formats and business-related fields.
* Integrates data from multiple source systems.
* Applies transformations to improve data quality and consistency.

### 🥇 Gold Layer — Business-Ready Data

* Creates analytical views and reporting-ready datasets.
* Integrates and aggregates data based on business requirements.
* Applies business logic and prepares data for analytical consumption.
* Organizes data using dimensional modelling concepts, including fact and dimension tables where applicable.
* Supports BI reporting, ad hoc analysis, and downstream machine learning use cases.

## 🔄 ETL Pipeline

The project implements an end-to-end Extract, Transform, and Load (ETL) process.

1. **Extract:** Ingest raw CRM and ERP data from CSV files.
2. **Load:** Load source data into the Bronze layer of SQL Server.
3. **Transform:** Clean, standardize, validate, and integrate data in the Silver layer.
4. **Model:** Apply business rules, aggregations, and analytical modelling in the Gold layer.
5. **Consume:** Make business-ready data available for reporting and analysis.

## 🛠️ Technologies Used

* **Database:** Microsoft SQL Server
* **Language:** T-SQL
* **Architecture:** Medallion Architecture
* **Data Integration:** ETL pipeline
* **Data Sources:** CRM and ERP CSV files
* **Data Modelling:** Fact and dimension modelling concepts(star schema)
* **Version Control:** Git and GitHub
* **Potential Consumers:** Power BI, BI reports, ad hoc analytics, and machine learning workflows

## 📂 Repository Structure

```text
Sql_Data_warehouse_project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── docs/
│   └── data_architecture.drawio
│
├── scripts/
│   ├── bronze/
│   │   ├── DDL_bronze.sql
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/
│   │
│   ├── gold/
│   │
│   └── init_database.sql
│
├── tests/
│
└── README.md
```

## 🎯 Key Learning Outcomes

* Designed a layered SQL data warehouse using the Medallion Architecture.
* Built ETL workflows using SQL Server and T-SQL.
* Worked with CRM and ERP data integration.
* Applied data cleansing, standardization, and transformation techniques.
* Organized analytical data into structured layers.
* Used Git and GitHub to manage and document project development.
* Designed a data architecture that supports business intelligence and analytical workloads.

## 📊 Business Value

This project demonstrates how raw operational data can be transformed into reliable, structured, and business-ready information. The layered architecture separates raw ingestion from data quality processing and analytical modelling, making the pipeline easier to maintain, extend, and troubleshoot.

## 👨‍💻 Author

**Farhat Kittur**

Data Analyst | SQL | Excel | Power BI | Python | Data Warehousing
