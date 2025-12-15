-- 1.	 Create a scalar function that takes date and returns Month name of that date.
create function getMonth(@dateVar date)
returns varchar(20)

	begin
		declare @monthResult varchar(20)
			select @monthResult = month(@dateVar)
	return @monthResult
	end 

select dbo.getMonth('5-28-2025')

-- 2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function printRangeValues(@firstNum int, @secondNum int)
returns @tableNumbers table(id int)
as
	begin
		declare @current int = @firstNum
		while @current <= @secondNum
			begin
				insert into @tableNumbers values(@current)
				set @current += 1
			end
	return
	end

select * from printRangeValues(1, 10)

-- 3.	 Create inline function that takes Student No and returns Department Name with Student full name.
create function getDeptName(@studentNum int)
returns table
as
	return(
		select d.Dept_Name, concat(s.St_Fname, ' ', s.St_Lname) as fullName
		from Student s inner join Department d
		on s.Dept_Id = d.Dept_Id
		where s.St_Id = @studentNum
	)

select * from getDeptName(2)

/*
4.	Create a scalar function that takes Student ID and returns a message to user 
	a.	If first name and Last name are null then display 'First name & last name are null'
	b.	If First name is null then display 'first name is null'
	c.	If Last name is null then display 'last name is null'
	d.	Else display 'First name & last name are not null'
*/

create function createMessage(@studentID int)
returns varchar(50)
as
	begin
		declare @messageToPrint varchar(50)
		declare @firstName varchar(50) = (select St_Fname from Student WHERE St_Id = @studentID)
		declare @LastName varchar(50) = (select St_Lname from Student WHERE St_Id = @studentID)

		if @firstName is null and @LastName is null
			select @messageToPrint = 'First name & last name are null'
		else if @firstName is null
			select @messageToPrint = 'first name is null'
		else if @LastName is null
			select @messageToPrint = 'last name is null'
		else
			select @messageToPrint = 'First name & last name are not null'
		return @messageToPrint
	end

SELECT dbo.createMessage(1);

-- 5.	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
create function displayManager(@managerId int)
returns table
as 
	return (
		select d.Dept_Manager, d.Dept_Name, i.Ins_Name , d.Manager_hiredate
		from Department d inner join Instructor i
		on d.Dept_Manager = i.Ins_Id
		where d.Dept_Manager = @managerId
	)

select * from displayManager(3)

/*
6.	Create multi-statements table-valued function that takes a string
	If string='first name' returns student first name
	If string='last name' returns student last name 
	If string='full name' returns Full Name from student table 
	Note: Use “ISNULL” function
*/
create function printStudentName(@format varchar(50))
returns @t table(newName varchar(50))
as 
	begin
		if @format = 'first name'
			insert into @t
				select  isnull(St_Fname, 'no first name') from Student
		else if @format = 'last name'
			insert into @t
				select  isnull(St_Lname, 'no last name') from Student
		else if @format = 'full name'
			insert into @t
				select  isnull(St_Fname, '---') + ' ' + isnull(St_Lname, '---') from Student
	return
	end

select * from printStudentName('first name')
select * from printStudentName('last name')
select * from printStudentName('full name')

-- 7.	Write a query that returns the Student No and Student first name without the last char
select s.St_Id, SUBSTRING(s.St_Fname, 1, LEN(s.St_Fname) - 1)
from Student s

-- 8.	Wirte query to delete all grades for the students Located in SD Department 
delete sc 
from Stud_Course sc inner join Student s
on sc.St_Id = s.St_Id
inner join Department d
on s.Dept_Id = d.Dept_Id
where d.Dept_Name = 'SD'

-- 9.	Using Merge statement between the following two tables [User ID, Transaction Amount]

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

-- 10.	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB 
-- then allow him to select and insert data into tables and deny Delete and update


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