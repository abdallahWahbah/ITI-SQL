-- 1.	Display (Using Union Function)
--			a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
--			b.	 And the male dependence that depends on Male Employee.
select d.Sex, d.Dependent_name
from Employee e inner join Dependent d
on e.ssn = d.ESSN 
where d.Sex = 'F' AND e.Sex = 'F'
union 
select d.Sex, d.Dependent_name
from Employee e inner join Dependent d
on e.ssn = d.ESSN 
where d.Sex = 'M' AND e.Sex = 'M'

-- 2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
select p.Pname, sum(w.Hours)
from Project p, Employee e, Works_for w
where e.SSN = w.ESSn and p.Pnumber = w.Pno
group by p.Pname

-- 3.	Display the data of the department which has the smallest employee ID over all employees' ID.
select d.*
from Departments d
where d.Dnum = (
	select e.Dno
	from Employee e
	where ssn = (select min(ssn) from Employee)
)
-- another solution
select d.* 
from Departments d inner join Employee e
on d.Dnum = e.Dno
where e.SSN = (select min(SSN) from Employee)

-- 4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select d.Dname, MIN(e.Salary), MAX(e.Salary), avg(e.Salary)
from Departments d inner join Employee e
on e.Dno = d.Dnum
group by d.Dname

-- 5.	List the last name of all managers who have no dependents.
select e.Lname
from Employee e inner join Departments d
on e.SSN = d.MGRSSN
where e.SSN not in (select dp.ESSN from Dependent dp)

-- 6.	For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select d.Dnum, d.Dname, count(e.SSN) 
from Departments d inner join Employee e
on d.Dnum = e.Dno
group by d.dnum, d.Dname
having avg(e.Salary) < (select avg(salary) from Employee)

-- 7.	Retrieve a list of employee’s names and the projects names they are working on ordered by department number 
-- and within each department, ordered alphabetically by last name, first name.
select e.Fname, e.Lname, p.Pname
from Employee e inner join Works_for w
on w.ESSn = e.SSN
inner join Project p
on p.Pnumber = w.Pno
order by e.dno, e.lname, e.fname

-- 8.	Try to get the max 2 salaries using sub query
select MAX(Salary)
from Employee
union 
select Max(salary) 
from Employee
where salary < (select Max(salary) from Employee)

-- 9.	Get the full name of employees that is similar to any dependent name
select Fname +' ' + Lname
from Employee
intersect
select Dependent_name 
from Dependent

-- 10.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select e.SSN, e.Fname
from Employee e
where exists (
	select 1
	from Dependent d
	where e.SSN = d.ESSN
)

-- 11.	In the department table insert new department called "DEPT IT”, with id 100, employee with SSN = 112233 as a manager for this department. 
-- The start date for this manager is '1-11-2006'
insert into Departments values('DEPT IT', 100, 112233, '1-11-2006')

-- 12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) moved to be the manager of the new department (id = 100), 
-- and they give you(your SSN =102672) her position (Dept. 20 manager) 
-- a.	First try to update her record in the department table
-- b.	Update your record to be department 20 manager.
-- c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
begin try
	begin transaction
		update Departments set MGRSSN = 968574 where Dnum = 100
		update Departments set MGRSSN = 102672 where Dnum = 20
		update Employee set superssn = 102672 where ssn = 102660
	commit
end try
begin catch
	rollback
	select ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER()
end catch

-- 13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database 
-- in case you know that you(your SSN =102672) will be temporarily in his position.
-- Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
begin try
	begin transaction
		delete from Dependent where ESSN = 223344
		update Departments set MGRSSN = 102672 where MGRSSN = 223344
		update Employee set Superssn = 102672 where Superssn = 223344
		delete from Works_for where ESSn = 223344
		delete from Employee where SSN = 223344
	commit
end try
begin catch
	rollback
	select ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER()
end catch

-- 14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
update Employee 
set Salary = (salary * 1.3)
where SSN in (
	select w.ESSn
	from Works_for w inner join Project p
	on w.Pno = p.Pnumber
	where p.Pname = 'Al Rabwah'
)
