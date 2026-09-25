--[Created Database and schema)
--Note : Used exists and rollback for duplication purposes and to ensure data integrity 


---Data warehouse Project ----

use master;

--drop and recreate database--
if exists ( select 1 from sys.databases where name =  'Datawarehouse')
begin
	alter Database Datawarehouse set single_user with rollback immediate;
	drop Database Datawarehouse;
end;
go

--create datawarehouse database-
create Database Datawarehouse;
go

use Datawarehouse;
go

create schema bronze;
go

create schema silver;
go 

create schema gold;
go
