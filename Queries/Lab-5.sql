-- 1.	Retrieve number of students who have a value in their age. 
select count(S.St_Age)
from Student S

-- 2.	Get all instructors Names without repetition
select distinct Ins_Name 
from Instructor

-- 3.	Display student with the following Format (use isNull function) >> Student ID - Student Full Name - Department name
select 
	isnull(St_Id, 0) as 'Student ID', 
	concat(s.St_Fname, ' ', s.St_Lname) as 'Student Full Name', 
	d.Dept_Name as 'Department name'
from Student s inner join Department d
on s.Dept_Id = d.Dept_Id

-- 4.	Display instructor Name and Department Name 
-- Note: display all the instructors if they are attached to a department or not
select i.Ins_Name, d.Dept_Name
from Instructor i left outer join Department d
on i.Dept_Id = d.Dept_Id

-- 5.	Display student full name and the name of the course he is taking
-- For only courses which have a grade  
select CONCAT(s.St_Fname, ' ', s.St_Lname) as fullName, c.Crs_Name
from 
Student s inner join Stud_Course sc
on sc.St_Id = s.St_Id
inner join Course c
on c.Crs_Id = sc.Crs_Id
where sc.Grade is not null

-- 6.	Display number of courses for each topic name
select count(t.Top_Id), t.Top_Name
from Topic t inner join Course c
on t.Top_Id = c.Top_Id
group by t.Top_Name

-- 7.	Display max and min salary for instructors
select min(i.Salary) as minSalary, MAX(i.Salary) as maxSalary
from Instructor i

-- 8.	Display instructors who have salaries less than the average salary of all instructors.
select * 
from Instructor i
where i.Salary < (select avg(Salary) from Instructor)

-- 9.	Display the Department name that contains the instructor who receives the minimum salary.
select d.Dept_Name
from Instructor i inner join Department d
on i.Dept_Id = d.Dept_Id 
where i.Salary = (select min(Salary) from Instructor)

-- 10.	 Select max two salaries in instructor table. 
select top(2) i.salary
from Instructor i
order by i.Salary desc

-- 11.	 Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT i.Ins_Name, COALESCE(CONVERT(VARCHAR(50), i.Salary), 'bonus')
FROM Instructor i

-- 12.	Select Average Salary for instructors 
select avg(i.salary)
from Instructor i

-- 13.	Select Student first name and the data of his supervisor 
select X.St_Fname, Y.*
from Student X, Student Y
where X.St_super = Y.St_Id

-- 14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select *
from (
	select *, 
	ROW_NUMBER() over (partition by Dept_Id order by salary desc) as RN
    from Instructor 
	where salary is not null) as newTable
where RN <= 2

-- 15.	 Write a query to select a random student from each department.  “using one of Ranking Functions”
select *
from (
	select *,
	ROW_NUMBER() over (partition by Dept_Id order by newId()) as RN
	from Student
	) as newTable
where RN = 1





------------------------
-- part 2
------------------------
use AdventureWorks2012

-- 1.	Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) 
-- to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select s.SalesOrderID, s.ShipDate
from Sales.SalesOrderHeader s
where s.ShipDate between '7-29-2014' and '7-28-2022'

-- 2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select p.ProductID, p.Name
from Production.Product p
where p.StandardCost < 110

-- 3.	Display ProductID, Name if its weight is unknown
select p.ProductID, p.Name
from Production.Product p
where p.Weight is null

-- 4.	 Display all Products with a Silver, Black, or Red Color
select *
from Production.Product p
where p.Color in('Silver', 'Black', 'Red')

--5.	 Display any Product with a Name starting with the letter B
select *
from Production.Product p
where p.Name like 'b%'

/*
	6.	Run the following Query
	UPDATE Production.ProductDescription
	SET Description = 'Chromoly steel_High of defects'
	WHERE ProductDescriptionID = 3
	Then write a query that displays any Product description with underscore value in its description.
*/
select *
from Production.ProductDescription p 
where p.Description like '%_%'

-- 7.	Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
select sum(s.TotalDue)
from Sales.SalesOrderHeader s
where s.ShipDate between '7-1-2001' and '7-31-2014'
group by s.OrderDate

-- 8.	 Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate
from HumanResources.Employee

-- 9.	 Calculate the average of the unique ListPrices in the Product table
select avg(distinct p.ListPrice)
from Production.Product p

-- 10.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format 
-- "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select concat('the ', p.Name, ' is only ', p.ListPrice)
from Production.Product p
where p.ListPrice between 100 and 120
group by p.ListPrice

/*
11.	
a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
Note: Check your database to see the new table and how many rows in it?
b)	Try the previous query but without transferring the data? 

*/

-- a 
select s.rowguid, s.Name, s.SalesPersonID, s.Demographics
into Store_Archive
from Sales.Store s

select * from dbo.Store_Archive

-- b
select s.rowguid, s.Name, s.SalesPersonID, s.Demographics
INTO store_Archive_Empty
from Sales.Store s
WHERE 1 = 2;

-- 12.	Using union statement, retrieve the today’s date in different styles using convert or format funtion. 
-- (explained in course lecture #9,10)
select format(getdate(), 'dd-MM-yyyy') -- 14-05-2025
union
select format(getdate(), 'dddd MMMM yyyy') -- Wednesday May 2025
union
select format(getdate(), 'ddd MMM yy') -- Wed May 25
union
select format(getdate(), 'dddd') -- Wednesday
union
select format(getdate(), 'MMM') -- May
union
select format(getdate(), 'hh:mm:ss') -- 11:57:33
union
select format(getdate(), 'HH') -- 24 format >> 23
union
select format(getdate(), 'hh tt') -- am, pm >> 11 PM
union
select format(getdate(), 'dd-MM-yyyy hh:mm:ss tt') -- 14-05-2025 11:58:30 PM
