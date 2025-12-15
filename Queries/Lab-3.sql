-- 1.	Display the Department id, name and id and the name of its manager.
select d.dnum, d.dname, e.ssn, e.fname
from Departments d inner join Employee e
on d.MGRSSN = e.ssn

-- 2.	Display the name of the departments and the name of the projects under its control.
select d.dname, p.pname
from Departments d inner join project p
on d.dnum = p.dnum

-- 3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select d.*, e.fname
from employee e inner join dependent d
on e.ssn = d.essn

-- 4.	Display the Id, name and location of the projects in Cairo or Alex city.
select p.pnumber, p.pname, p.plocation
from project p
where p.city in ('Cairo', 'alex')

-- 5.	Display the Projects full data of the projects with a name starts with "a" letter.
select p.*
from project p
where p.pname like 'a%'

-- 6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select e.*
from Departments d inner join Employee e
on e.dno = d.dnum 
where 
	e.salary between 1000 and 2000
	and d.dnum = 30

-- 7.	Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.
select e.Fname, e.Lname
from Employee e, Works_for w, Project p
where 
	e.ssn = w.essn
	and p.Pnumber = w.Pno
	and e.dno = 10 
	and p.pname = 'AL Rabwah' 
	and w.Hours >= 10

-- 8.	Find the names of the employees who directly supervised with Kamel Mohamed.
select y.fname, y.lname
from Employee x, Employee y
where 
	x.ssn = y.Superssn
	and x.Lname = 'mohamed'
	and x.fname = 'Kamel' 

-- 9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.Fname, p.Pname
from Employee e, Works_for w, Project p
where 
	e.ssn = w.essn 
	and w.pno = p.pnumber
order by p.Pname

-- 10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select p.Pnumber, d.Dname, e.Lname, e.Address, e.Bdate
from project p, Departments d, Employee e
where
	p.city = 'cairo'
	and p.dnum = d.dnum 
	and e.ssn = d.mgrssn

-- 11.	Display All Data of the managers
select e.* 
from Employee e inner join Departments d
on e.ssn = d.MGRSSN

-- 12.	Display All Employees data and the data of their dependents even if they have no dependents
select e.*, d.*
from Employee e left outer join Dependent d
on e.SSN = d.ESSN

-- 13.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno)
VALUES ('Abdallah', 'Wahbah', 102672, '1998-05-15', 'Cairo', 'M', 3000, 112233, 30);

-- 14.	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, 
-- but don’t enter any value for salary or supervisor number to him.
INSERT INTO Employee (Fname, Lname, SSN, Bdate, Address, Sex, Dno)
VALUES ('Mostafa', 'Mahmoud', 102660, '1998-05-15', 'Cairo', 'M', 30);

-- 15.	Upgrade your salary by 20 % of its last value.
update Employee 
set Salary = Salary * 1.2
where ssn = 102672





------------------------------- part 2 
create table Instructor(
   id int primary key identity,
   salary int default 3000,
   overtime int unique, 
   bd date,
   FName varchar(50),
   LName varchar(50),
   hiredate date default getdate(),
   address varchar(50),
   netsalary as (salary + overtime),
   age as year(getdate()) - year(bd),
   constraint c1 check(address in ('Cairo', 'Alex')),
   constraint c2 check(salary between 1000 and 5000),
)

create table Course(
   CID int primary key identity,
   CName varchar(50),
   CDuration int unique,
)

create table Lab(
   LID int primary key identity,
   LLocation varchar(50),
   capacity int,
   cid int,
   constraint c1 foreign key(cid) references course(cid)
		on delete cascade on update cascade,
   constraint c2 check(capacity < 20),
)

create table Instructor_Teach_Course(
   id int,
   cid int,
   constraint c1 foreign key(id) references instructor(id)
		on delete cascade on update cascade,
   constraint c2 foreign key(cid) references course(cid)
	    on delete cascade on update cascade,
   constraint c3 primary key(id, cid),
)