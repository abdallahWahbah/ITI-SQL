----------------------------------------------------
-- Stores Procedure, Trigger, top() with dml
----------------------------------------------------



----------------------------------------------------
-- Stored procedure >>> you can find your sp in ITI DB, programmability, stored procedures
----------------------------------------------------
-- creation
create proc getStudentById @id int
as 
	select * 
	from student 
	where St_Id = @id

-- usage
getStudentById 1


-- sp with no params
create proc getStudentName -- students name in their dept
as
	select St_Id, St_Fname, St_Lname
	from Student s, Department d
	where s.Dept_Id = d.Dept_Id

-- usage
execute getStudentName -- you can use 'execute' keyword beford using the sp or not use it (unsless you use "insert into" with sp: mandatory)


create proc insertStudentIDName @id int, @name varchar(30)
as
	begin try
		insert into Student(St_Id, St_Fname)
		values(@id, @name)
	end try
	begin catch
		select 'Duplicate ID', ERROR_LINE(), ERROR_MESSAGE(), ERROR_NUMBER()
	end catch

-- usage
insertStudentIDName 15, 'ahmed'


-- sp with default parameters
create proc sumTwoNumbers @x int, @y int = 100 
as 
	select @x + @y

--usage
execute sumTwoNumbers 10, 9 -- calling by position (default >> pass x then pass y)
execute sumTwoNumbers @y = 90, @x = 1 -- calling by name (parameter order is not mandatory)
execute sumTwoNumbers 6 -- calling with default value


-- sp + insert into
create proc getStudentByAddress2 @add varchar(20)
as
	select St_Id, St_Fname, St_Lname
	from Student
	where St_Address = @add

--usage
insert into table3 -- supposing table3 exists
execute getStudentByAddress2 'cairo'


-- sp with return data >> the same idea as "pass by ref" when writing output, "pass by val" when not writing output keyword
alter proc getStudentAge @id int, @age int output, @name varchar(30) output
as
	select @age = St_Age, @name = St_Fname
	from Student
	where St_Id = @id

-- usage
declare @ageResult int, @nameResult varchar(30)
execute getStudentAge 1, @ageResult output, @nameResult output
select @ageResult, @nameResult


-- sp + dynamic query (not preferred cause it leverages the performance)
create proc getAll @col varchar(30), @t varchar(30)
with encryption
as
execute('select ' + @col + ' from ' + @t)

-- usage
getAll '*', 'Student'

----------------------------------------------------
-- Trigger: Before, After, Instead of
----------------------------------------------------

-- trigger is a special type of sp called after a certain event (insert, update, delete)
-- trigger to print message after inserting enew student
create trigger t1
on Student
after insert
as
	select 'New student is inserted'

insert into Student(St_Id, St_Fname)  -- 'New student is inserted' will be printed after running the insert statement
values(41, 'asdaljsdn')


-- trigger to print the date at which the course is updated
create trigger t2
on course
for update -- 'for' = 'after'
as
	select GETDATE()

update course set Crs_Duration += 1 


-- trigger to prevent the current user from updating, inserting, deleting from instructor table (read only for this table)
alter trigger t3
on instructor
instead of update, insert, delete
as
	select 'not allowed for user = '+SUSER_SNAME()

update Instructor set Salary += 1
delete from Instructor where Ins_Id = 10


-- disble trigger
alter table instructor disable trigger t3


-- trigger with if 
create trigger t4
on course
after update 
as
	if update(st_name) -- if you are updating the course name
		select 'you have updated the course name'


-- trigger with inserted, deleted tables >>> print the old and new updated row
create trigger t5
on Employee
after update
as
	select * from inserted -- print the old row that is updated
	select * from deleted -- print the new row that is updated

-- usage
update Employee 
set Salary = 10, Fname = 'abdallah'
where ssn = 11


-- example on inserted table: trigger to prevent insret on Friday
-- the idea is to delete the inserted row on friday
create trigger t6
on Employee
after insert
as
	if format(GETDATE(), 'dddd') = 'friday'
		begin
			select 'Unable to insert on Friday'
			delete from Employee 
				where ssn = (select ssn from inserted)
		end


-- example on inserted and deleted tables: prevent update, and store information about the person who tried to update like name, date
create table history
(
	_user varchar(50),
	_date date,
	_old int,
	_new int
)

create trigger t7
on topic 
instead of update
as
	if update(top_id)
	begin
		declare @new int, @old int
		select @old = top_id from deleted -- row before updateing containing old id
		select @new = top_id from inserted -- row after updating containint new id
		insert into history
			values(SUSER_NAME(), GETDATE(), @old, @new)
	end


-- runtime trigger (automatic trigger when you run the code)
delete from Instructor
	output deleted.salary
	where Ins_Id = 1

update Instructor
	set Salary *= 1.1
	output GETDATE(), SUSER_NAME(), inserted.Salary, deleted.Salary
	-- output GETDATE(), SUSER_NAME(), inserted.Salary, deleted.Salary into AuditHistoryTable
	where Ins_Id = 1



-- Give an example for top with DML query
delete top (10) 
	from Employee 
	where Fname like 'ja%%'

update top(10) Employee
	set Fname = 'janesssssss'
	where Fname like 'ja%%'

insert into TempTable(SSN, Fname, Lname)
	select top(10) SSN, Fname, Lname
	from Employee
	where Fname like 'ja%%' 




