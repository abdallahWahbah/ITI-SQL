---------------------------------
-- full path object, chema, select into, insert into, merge
---------------------------------


---------------------------------
-- full path object, schema
---------------------------------

-- [serverName].[DBName].[SchemaName].[objectName]
select dept_name from ABDALLAHWAHBAH.ITI.dbo.Course
union 
select dname from Company_SD.dbo.Departments

---------------------------------
-- select into (DDL): create table from existing table
---------------------------------
-- copy student table with its data to newTable
select * into newTable 
from student

-- change the schema name
create schema HR

alter schema HR transfer student -- >>>>>> change the schema name from dbo to hr >>>> dbo.student to be HR.student

-- copy table from the current database to another database
select * into company_sd.dbo.anyTable 
from student 

-- false condition >>> copy the table structure only
select *
from student
where 1=2 

---------------------------------
-- insert beased on select (DML): to take the result of select statement and paste it in another table
---------------------------------

-- simple insert
insert into table5
values(1, 'ahmed')

-- insert constructor
insert into table5
values(1, 'ahmed'), (2, 'abdallah'), (3, 'ali')

-- insert based on select
insert into table5
select St_Fname, St_Address from student where st_age > 10

-- bulk insert (insert data from file): if you have a file.txt with rows with the following format >> id, name 
-- 1,ahmed
-- 2, abdallah
-- and you want to insert this data to your table
bulk insert table5
from 'G:\myFile.txt'
with (fieldterminator=',')

-- insert with sp >>> look at Lec-8


---------------------------------
-- merge (please refer to screenshot #283: #286
---------------------------------

create table LastTransaction 
(xid int, xname varchar(50), xval int)

create table DailyTransaction 
(yid int, yname varchar(50), yval int)

merge into LastTransaction as T -- Target table
using DailyTransaction as S -- source table
on T.xid = S.yid

when matched then
	update
	set T.xval = S.yval
when not matched then
	insert
	values(S.yid, S.yname, S.yval);




--10 steps of security
-----------------------
--1-change auth mode >>> right click on server, properties, security, choose server authentication >> sql server and windows authentication mode
--2-restart service >> right click on server, restart
--3-create login >> open security, right click on login, new login, choose sql server authentication, write login name, password, unchick all
--4-create user >> open database, security, right click on users, new user, fill the username and login name with the same thing

--5-create schema
--6-assign tables in schema
--7-link schema +user

--8-set permissions >> right click on the table, permissions, search, browse, choose the user, select grant and deny, restart the whole application
--9-disconnect --reconnect
--10-test queries --new query