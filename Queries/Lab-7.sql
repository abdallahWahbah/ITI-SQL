-- 1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 
create view studentFullNameView
with encryption
as
	select s.St_Fname, c.Crs_Name
	from Student s inner join Stud_Course sc 
	on sc.St_Id = s.St_Id
	inner join Course c
	on c.Crs_Id = sc.Crs_Id
	where sc.Grade > 50

select * from studentFullNameView


-- 2.	 Create an Encrypted view that displays manager names and the topics they teach. 
alter view ManagerTopicView
with encryption
as
	select d.Dept_Manager, t.Top_Name
	from Instructor i 
		inner join Ins_Course ic on i.Ins_Id = ic.Ins_Id
		inner join Course c on c.Crs_Id = ic.Crs_Id
		inner join Topic t on t.Top_Id = c.Top_Id
		inner join Department d on d.Dept_Id = i.Dept_Id

select * from ManagerTopicView


-- 3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department  		
create view instructorDeptView
with encryption 
as
	select i.Ins_Name, d.Dept_Name
	from Instructor i inner join Department d
	on i.Dept_Id = d.Dept_Id
	where d.Dept_Name in ('SD', 'Java')

select * from instructorDeptView


/*
-- 4.	 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
	Note: Prevent the users to run the following query 
	Update V1 set st_address=’tanta’
	Where st_address=’alex’;
*/
create view V1
with encryption
as
	select *
	from Student s
	where s.St_Address in ('Alex', 'Cairo')
	with check option

update v1 set St_Address = 'tanta' where St_Address = 'alex'


-- 5.	Create a view that will display the project name and the number of employees work on it. “Use Company DB”
use Company_SD

create view projectEmployeeView
with encryption
as
	select p.Pname, count(e.SSN)
	from Employee e 
		inner join Works_for w on e.SSN = w.ESSn
		inner join Project p on p.Pnumber = w.Pno
		group by p.Pname

select * from projectEmployeeView


/*
	6.	Create the following schema and transfer the following tables to it 
	a.	Company Schema 
	i.	Department table (Programmatically)
	ii.	Project table (by wizard)
	b.	Human Resource Schema
	i.	  Employee table (Programmatically)
*/
create schema company
alter schema company transfer department
-- change by wizard >>> right click on table, design, properties (if not exists, right click on space, properties), change schema
create schema hr
alter schema hr transfer employee


-- 7.	Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. What will happen?  -? Use ITI DB
use ITI
create clustered index i1 -- error: The operation failed because an index or statistics with name 'i1' already exists on table 'Department'.
on Department(Manager_hiredate)


-- 8.	Create index that allow u to enter unique ages in student table. What will happen?  -? Use ITI DB
use ITI
create unique index i2
on Student(st_age)


-- 9.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
use Company_SD

declare c1 cursor
for select salary
	from Employee
	where SSN is not null
for update

declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS = 0
	begin
		if @sal < 3000
			update Employee set Salary *= 1.1
			where current of c1
		else if @sal >= 3000
			update Employee set Salary *= 1.2
			where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1


-- 10.	Display Department name with its manager name using cursor. Use ITI DB
use ITI

declare c2 cursor
for select d.Dname, i.Ins_Name
	from Department d inner join Instructor i
	on d.Dept_Manager = i.Ins_Id
for read only

declare @deptName varchar(50), @managerName varchar(50)
open c2
fetch c2 into @deptName, @managerName
while @@FETCH_STATUS = 0
	begin
		select @deptName, @managerName
		fetch c2 into @deptName, @managerName
	end
select @deptName, @managerName
close c2
deallocate c2



-- 11.	Try to display all instructor names in one cell separated by comma. Using Cursor . Use ITI DB
use ITI

declare c3 cursor
for select Ins_Name
	from Instructor
	where Ins_Name is not null
for read only

declare @currentName varchar(50), @finalResult varchar(50)
open c3
fetch c3 into @currentName
while @@FETCH_STATUS = 0
	begin
		set @finalResult = CONCAT(@finalResult, ', ' @currenName)
		fetch c3 into @currentName
	end
select @finalResult
close c3
deallocate c3


-- 12.	Try to generate script from DB ITI that describes all tables and views in this DB
/*
	- Right-click on the ITI DB, Tasks, Generate Scripts, Specific objects, choose Tables and Views, next....
*/


