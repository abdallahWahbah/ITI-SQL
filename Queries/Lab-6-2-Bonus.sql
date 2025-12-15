-- 1.	Give an example for Hierarch id Data type
-- https://sqlrob.com/2024/08/01/hierarchyid/

CREATE TABLE EmployeeTest2(
    ID int PRIMARY KEY IDENTITY (1,1),
    FirstName varchar(30) NOT NULL,
    LastName varchar(30) NOT NULL,
    ReportsTo hierarchyid NOT NULL UNIQUE,
);
 
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Big', 'Boss', '/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Jane', 'Doe', '/1/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('John', 'Doe', '/1/1/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Mike', 'Smith', '/1/1/1/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Sally', 'Jones', '/2/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Tom', 'Jackson', '/2/1/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Chris', 'Johnson', '/3/');
INSERT INTO dbo.EmployeeTest2(FirstName, LastName, ReportsTo) 
    VALUES ('Michelle', 'Williams', '/3/1/');

 /*
						Big Bose
				Jane Doe		Sally Jones			Chris Johnson
			John Doe				Tom Jackson			Michelle Williams
		Mike Smith				
*/

-- HierarchyPath
SELECT FirstName, LastName, ReportsTo.ToString() as HierarchyPath
FROM EmployeeTest2;

-- HierarchyLevel
SELECT FirstName, LastName, ReportsTo.GetLevel() as HierarchyLevel
FROM dbo.EmployeeTest2;

-- IsDescendantOf
DECLARE @ID hierarchyid;
SELECT @ID = ReportsTo FROM EmployeeTest2 WHERE FirstName = 'Jane'
 
SELECT concat(FirstName, ' ', LastName) as fullName, ReportsTo.ToString() as HierarchyPath
FROM EmployeeTest2
WHERE ReportsTo.IsDescendantOf(@ID) = 1;


-- 2.	Create a batch that inserts 3000 rows in the employee table. The values of the emp_no column should be unique and between 1 and 3000. 
-- All values of the columns emp_lname, emp_fname, and dept_no should be set to 'Jane', ' Smith', and ' d1', respectively.”USE CompnayDB”

use Company_SD

declare @counter int 
set @counter = 1
while @counter < 3000
	begin
		insert into Employee(SSN, Lname, Fname, Dno) values (@counter, 'Jane', 'Smith', 10)
		set @counter += 1
	end 

-- 3.	 Give an example for CTE (common type expression)
with highSalariesCTE as
(
	select SSN , Fname, Lname, Salary
	from Employee
	where Salary > 2000
)
select SSN, Fname, Lname
from highSalariesCTE

-- 4.	Give an example for top with DML query
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
