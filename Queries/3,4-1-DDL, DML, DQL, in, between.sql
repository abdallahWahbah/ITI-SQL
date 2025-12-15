---------------------------------------
-- DDL, DML, DQL, in, between
---------------------------------------


---------------------------------------
-- DDL (Data Definition Language): create, alter, drop
---------------------------------------
create table emp
(
	eid int primary key, -- 'identity(1, 1)' for auto increment if you want
	ename varchar(20) not null,
	eage int,
	eadd varchar(20) default 'cairo',
	hiredate date default getdate(),
	Dnum int
)

-- add column
alter table emp add sal int

-- change column datatype
alter table emp alter column sal bigint

-- delete column
alter table emp drop column sal

-- drop table data and structure
drop table emp



---------------------------------------
-- DML(data manipulation language): insert, update, delete
---------------------------------------
insert into emp values(1, 'abdallah', NULL, 'Dakahlia', '02/27/2025', 10, 7500) -- last value is for salary which is added by alter
insert into emp(eid, ename) values(2, 'mahmoud') -- insert certain columns
-- insert constructor (mutiple rows in one query) 
insert into emp(eid, ename) values(3, 'abdelbary'), (4, 'abdallah') 

update emp set ename='ABDALLAH' where eid=1
update emp set eage+=1

select * from emp

-- delete all rows but keep structure
delete from emp
-- delete table rows and structure
drop table emp
-- delete one row
delete from emp where eid=4
-- delete column
alter table emp drop column sal



---------------------------------------
-- DQL (Data Query Language): select, order by, alias, not null, asc desc, and or, distinct, in, between
---------------------------------------

-- *, order by
select * from emp
select ename, eadd, hiredate from emp
select ename, eadd from emp where eid=1
select * from emp order by eage asc -- default is asc
select * from emp order by eage desc -- descending

-- alias: combining two columns into one column (not affecting the original table, just in runtime, can't access the new column later)
select ename + ' ' + eadd as fullname from emp where eid=1
-- to add space between column title words
select ename + ' ' + eadd [full name] from emp where eid=1

-- is null, is not null, and, or
select ename from emp where Dnum is null
select ename from emp where Dnum is not null
select ename from emp where Dnum is not null and eadd='Dakahlia'

-- distinct (unique values and order)
select distinct ename from emp

-- in, between (syntax)>>>> in(, )     between num1 and num2
-- in (equals to 'or')
select ename from emp where Dnum in (10, 20) -- the same as >>>  select ename from emp where Dnum=10 or Dnum=20

-- between (range)
select ename from emp where eage >= 30 and eage <= 60
select ename from emp where eage between 30 and 60 -- the same as above (including min and max)




