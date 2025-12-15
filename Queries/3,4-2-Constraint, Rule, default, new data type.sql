---------------------------------------
-- Constraint, Rule, default, new data type (in ITI not youtube)
---------------------------------------


---------------------------------------
-- Constraint
---------------------------------------
create table emps(
  eid int,
  ename varchar(20),
  eadd varchar(20) default 'cairo',
  hiredate date default getdate(),
  salary int,
  overtime int,
  netsal as (salary + overtime) persisted, -- computed attribute + saved on hard disk
  gender varchar(1),
  bd date,
  age as year(getdate()) - year(bd), -- computed attribute but not saved
  hours_rate int not null,
  dum int,
  constraint c1 primary key(eid, ename), -- composite primary key (pk)
  constraint c2 unique(salary),
  constraint c3 unique(overtime),
  constraint c4 check(salary > 1000),
  constraint c5 check(overtime between 100 and 500),
  constraint c6 check(eid in ('cairo', 'alex', 'mansoura')),
  constraint c7 check(gender='f' or gender='m'),
  constraint c8 foreign key(dnum) references depts(did)
	on delete set null on update cascade, -- when delete row in depts(containing primary key), set null in the emp row containing the same dnum 
	-- and when updating, update both rows in the 2 tables
)

-- delete constraint
alter table emps drop constraint c3
-- add constraint using alter
alter table emps add constraint c9 check(hours_rate > 9)


---------------------------------------
-- Rule
---------------------------------------
create rule r1 as @x>1000

sp_bindrule r1, 'instructor.salary'
sp_bindrule r1, 'emps.overtime'

-- delete rule
sp_unbindrule 'emps.overtime'
drop rule r1


---------------------------------------
-- default: in ITI not youtube
---------------------------------------
create defualt def1 as 10000
sp_bindefault def1, 'emps.salary'

sp_unbindefault 'emps.salary'
drop default def1


---------------------------------------
-- create new data typep ( in ITI not youtube ) int, >5000, default=10000
---------------------------------------
sp_addtype complexDataType, 'int'
create rule r1 as @x>5000
create default def1 as 10000

sp_bindrule r1, complexDataType
sp_bindefault def1, complexDataType

create table myStaff(
   id int primary key identity,
   ename varchar(50),
   salary complexDataType
)

