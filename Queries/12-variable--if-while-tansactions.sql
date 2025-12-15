------------------------------------------------------
-- local and global variables, table variable, dynamic query, 
-- flow statements: if, if exists, if not exists, try/catch, while loop, case, iif
-- transaction: set of queries executed together
-- windowing functions
------------------------------------------------------

------------------------------------------------------
-- local variable
------------------------------------------------------

-- variable declaration 
declare @x int

-- assign value using 2 ways
set @x = 10 
-- or 
select @x = 10

-- display variable value
select @x -- will not run if you runned it alone, defined on batch, you need to run it with declaring >>> declary @x int ... select @x >> highlight the 2 lines


-- assign (((select statement))) value to variable
declare @x int = (select avg(std_Age) from student)
select @x

declare @y int = 10
select @y = std_Age from student where std_id=102 
-- if the return is null, the variable will save the last value it had
-- if the select statement returns multiple values (array), it will assign the last value to the variable
select @y

declare @studentAge int = 10, @studentName varchar(20) = 'Hoksha'
select @studentAge = std_Age, @studentName = std_fname from student where std_id=102 
select @studentAge, @studentName


-- assigning with (((update statment)))
declare @z int
update student 
	set std_Fname='Bobsssss', @z = dept_id
where std_id = 102
select @z


------------------------------------------------------
-- Global variable >>> built-in functions, can't assign values to them, display only
-- starts with @@
------------------------------------------------------
set @x = @@servername -- assigning global variable to local variable
-- most popular global variables
@@servername
@@version
@@rowcount -- return num of rows affected of last statement you run
@@error -- return (0 or number) 0: no error, number: the last query is fault (with message)
@@identity -- return (null or number) number: if you insert on table having identity, return the row identity number you inserted, or return null if no identity column in the table


------------------------------------------------------
-- table variable
------------------------------------------------------
-- to work with array >> we use table
declare @myTable table(id int, name varchar(20))
insert into @myTable values(1, 'abdallah'), (2, 'mahmoud')

-- insert data from another table
insert into @myTable 
	select std_id, std_fname from student where std_Address = 'cairo'

select * from @myTable

------------------------------------------------------
-- dynamic query
------------------------------------------------------

-- select with dynamic variable
declare @age int = 1
select * from student where std_Age = @age

-- top with dynamic variable
declare @topVal int = 4
select top(@topVal) * from student

-- dynamic query using execute: take a string and converts it to a query
execute('select * from student') -- execute: transfers string to query during runtime

declare @cols varchar(20)= '*', @tableName varchar(20)= 'student', @whereCondition varchar(20)='std_age >= 20'
execute('select ' + @cols + ' from ' + @tableName + ' where ' + @whereCondition)


------------------------------------------------------
-- if - else - begin - end
------------------------------------------------------

declare @rowsAffected int
update student set std_age+=1
select @rowsAffected = @@ROWCOUNT -- number of rows affected by update statement

if @rowsAffected > 0 
	select 'Multi rows affected' -- like print statement
else if 5 > 19
	select 'impossible to run'
else
	begin -- begin - end for multiple statements >> no '{}'
		select 'Zero rows affected'
		select 'Idiot'
	end


------------------------------------------------------
-- if exists, if not exists
------------------------------------------------------

-- check if student table exists or not 
if exists(select name from sys.tables where name='student') 
-- sys.tables >>> get metadata about tables
	select ('table exists')
else 
	begin
		select 'please, create a new table' 
		-- create table (id int, name varchar(20)) ..... 
	end


-- delete a certain department if there is no relationship with student (if there is no students in dept #20)
-- try/catch is more simpler
if not exists (select dept_id from student where dept_id=20)
	delete from department where dept_id = 20
else
	select 'you cannot delete this table, table has relationship'


------------------------------------------------------
-- try/catch
------------------------------------------------------
-- delete like above in a simpler way
begin try
	delete from department where dept_id = 20
end try
begin catch
		select 'you cannot delete this table, table has relationship'
end catch


------------------------------------------------------
-- while loop only for looping, no (for, foreach, do while) in sql
------------------------------------------------------

declare @x int = 10
while @x <= 20
	begin
		set @x += 1
		if @x = 14
			continue
		if @x = 16
			break
		select @x
	end -- result: 11, 12, 13, 15

------------------------------------------------------
-- case (don't run the code)
------------------------------------------------------
SELECT 
    ProductName,
    Quantity,
    CASE 
        WHEN Quantity > 10 THEN 'High Stock'
        WHEN Quantity BETWEEN 5 AND 10 THEN 'Medium Stock'
        ELSE 'Low Stock'
    END AS StockLevel -- as StockLevel: runtime variable
FROM Products;

update Instructor
	set salary = 
		case 
			when salary > 5000 then salary * 1.2
			else salary * 1.8
		end


------------------------------------------------------
-- iif (don't run the code): like ternary operator in js >>> const x = true ? 'true' : 'false'
------------------------------------------------------
SELECT 
    ProductName,
    IIF(Quantity > 10, 'High Stock', 'Low or Medium Stock') AS StockStatus 
FROM Products;


------------------------------------------------------
-- transaction: set of queries executed together
-- if any query is down, all queries will rollback (undo everything)
------------------------------------------------------

-- don't run the code
begin try
	begin transaction
		insert into child values(1)
		insert into child values(2)
		insert into child values(3)
	commit
end try
begin catch
	rollback -- if error occured, rollback (undo all queries in the transaction)
end catch










