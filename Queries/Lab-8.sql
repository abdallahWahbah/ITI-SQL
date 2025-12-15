-- 1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
create proc numOfStudentPerDept
as 
	select count(s.St_Id), d.Dept_Name
	from Student s inner join Department d
	on s.Dept_Id = d.Dept_Id
	group by d.Dept_Name

execute numOfStudentPerDept


/*
	2.	Create a stored procedure that will check for the # of employees in the project p1 
	if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
	if they are less display a message to the user “'The following employees work for the project p1'” in addition to the first name and last name of each one. 
	[Company DB] 
*/
use Company_SD

create proc numOfEmployees
as 
	begin
		declare @empCount int
		select @empCount = count(e.SSN)
		from Project p 
		inner join Works_for w on p.Pnumber = w.Pno
		inner join Employee e on e.SSN = w.ESSn
		where p.Pname = 'p1'

		if @empCount >= 3
			select 'The number of employees in the project p1 is 3 or more'
		else
		begin 
			select 'The following employees work for the project p1'
			select e.Fname, e.Lname
				from Project p 
				inner join Works_for w on p.Pnumber = w.Pno
				inner join Employee e on e.SSN = w.ESSn
				where p.Pname = 'p1' 
		end

	end


/*
	3.	Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
	The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. 
	[Company DB]
*/
use Company_SD

create proc replaceEmployees @oldEmp int, @newEmp int, @projectNumber int 
as
	begin 
		if exists (
			select * 
			from Works_for
			where ESSn = @oldEmp and pno = @projectNumber
		)
		begin
			update Works_for
			set ESSn = @newEmp
			where ESSn = @oldEmp and Pno = @projectNumber
		end
		else
			select 'Old employee is not assigned to this project'
	end


/*
	4.	add column budget in project table and insert any draft values in it then 
	then Create an Audit table with the following structure 
	ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 

	This table will be used to audit the update trials on the Budget column (Project table, Company DB)
	Example:
		If a user updated the budget column then the project number, user name that made that update, 
		the date of the modification and the value of the old and the new budget will be inserted into the Audit table
	Note: This process will take place only if the user updated the budget column
*/
alter table project add budget int
update project set budget = 50000 where pname = 'p1'

create table AuditProject(
	ProjectNo int,
    UserName varchar(30),
    ModifiedDate date,
    Budget_Old int,
    Budget_New int
)

create trigger updateProjectTrigger
on Project
after update
as
	begin
		if update(budget)
			begin
				declare @newBuget int, @oldBudget int, @projectnumber int
				select @newBuget = budget from inserted
				select @oldBudget = budget from deleted
				select @projectnumber = pnumber from inserted
				insert into AuditProject
					values(@projectnumber, SUSER_NAME(), GETDATE(), @oldBudget, @newBuget)
			end
	end


/*
	5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
	“Print a message for user to tell him that he can’t insert a new record in that table”
*/
use ITI

create trigger preventInsert
on Department
instead of insert
as 
	select 'Print a message for user to tell him that he can’t insert a new record in that table'


-- 6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
use Company_SD

create trigger preventInsertOnEmployee
on Employee
instead of insert
as 
	select 'Print a message for user to tell him that he can’t insert a new record in that table'


-- 7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) 
-- where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”

create table AuditStudent(
	id int identity(1, 1) primary key,
	username varchar(30),
	modifingDate date,
	note varchar(100)
)

create trigger afterInsertStudent
on Student
after insert 
as
	begin 
		insert into AuditStudent(username, modifingDate, note)
		select 
			SUSER_NAME(),
			GETDATE(),
			CONCAT(SUSER_NAME(), ' Insert New Row with Key= ', i.st_id, ' in table Studednt')
			from inserted i
	end


-- 8.	 Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) 
-- where note will be“ try to delete Row with Key=[Key Value]”
create trigger insteadOfDeleteStudent
on Student
instead of delete
as 
	begin 
		insert into AuditStudent(username, modifingDate, note)
		select 
			SUSER_NAME(),
			GETDATE(),
			CONCAT('try to delete Row with Key=', d.st_id)
			from deleted d
	end 



