---------------------------------
-- top(), top() with ties, newid(), data types, switch case, format, convert
-- Ranking function: Row_Number(), Dense_rank(), NTiles(Group), Rank()
-- built-in functions
---------------------------------

-- top(), top() with ties, newid()

-- top(): first n rows
select top(3) * 
from student
where std_age > 25

select top(3) std_fname 
from student

-- get highest 2 salaries
select top(2) salary
from instructor
order by salary asc

-- top() with ties >>> works only with 'order by', if there is match with the last row in the 'order by', return it also
select top(3) with ties * 
from student 
order by std_Age

-- newid(): GUID(global universal ID)
select newid()

select *, newid() -- it will add unique random 'id' column to each row (in runtime)
from student

-- get 3 random students
select top(3)*
from student
order by newid() -- random



---------------------------------------
-- Ranking function: Row_Number(), Dense_rank(), NTiles(Group), Rank() >>>> please refer to screenshots #178
-- Row_number() >>> make a new order rather than dept_id based on (order by)
-- dense_rank() >>> make a new order rather than dept_id based on (order by), and when 2 or more rows have the same result of (orber by), give them the same order
-- NTiles(3) >>> divide the data into (ex:) 3 groups
---------------------------------------

-- get the 3rd highest age
select * 
from (
	select *, row_number() over (order by std_age) as RN
	from student ) as newTable
	-- i can't use 'where' here because of execution order, that's why i will make a subquery
where RN = 3

-- get the 3rd highest age with duplication (if more than one student have the same age)
select * 
from (
	select *, dense_rank() over (order by std_age) as DR
	from student ) as newTable
where DR = 3

-- get the 2 highest age in each dept (using partition by)
select * 
from (
	select *, row_number() over (partition by dept_id order by std_age) as RN
	from student ) as newTable
where RN <= 2

-- example the same as above
-- 14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select *
from (
	select *, 
	ROW_NUMBER() over (partition by Dept_Id order by salary desc) as RN
    from Instructor 
	where salary is not null) as newTable
where RN <= 2


-- split each department into 2 group
select *
from(
	select *, NTILE(2) over (partition by dept_id order by st_id) as G
) as newTable


---------------------------------------
-- Data types
---------------------------------------

------------ Numeric
-- bit			-- boolean 0:1 true:false 
-- tinyint		-- 1 Byte >> (unsigned: -127 to +127) or (signed: 0:255)
-- smallint		-- 2 Byte >> (unsigned: -23768 to 23768) or signed (0:65555)
-- int			-- 4 Byte
-- bigint		-- 8 Byte

------------ Decimal
-- smallmoney	-- 4 digits >> .0000
-- money		-- 8 digits >> .000000
-- real			-- 7 digits .0000000
-- float	
-- dec, decimal	-- (most used) >>> dec(5, 2) number of 5 digits, 2 of them are decimal >> ex: 123.52

------------ Text
-- char(10)		-- fixed length of 10 letters stored in the memory even if not taken
-- varchar(10)	-- variable length >> store number of letters in the memory up to 10 letters
-- nchar(10)	--  unicode char: allows non-english char like arabic instead of ????
-- nvarchar(10) -- unicode char with variable length
-- nvarchar(max) -- unspecified length tp to 2GB

------------ DateTime
-- Date							-- MM/DD/YYYY
-- Time							-- hh:mm:ss.452 >> default seconds have 3 digits
-- time(7)						-- hh:mm:ss.1234567 >> 7 digits for nano tasks
-- smalldatatime				-- MM/DD/YYYY hh:mm:00 >>> year of max 100, can't type 2025
-- datetime						-- MM/DD/YYYY hh:mm:ss.545 >> year range [1753:9999]
-- datetime2(7)					-- MM/DD/YYYY hh:mm:ss.5457589 >> year range [1:9999]
-- datetimeoffset				-- MM/DD/YYYY hh:mm:ss.5457589 +2:00 (time zone like cairo)

------------ binary
-- binart 0101101000
-- image

------------ other
-- xml
-- unique_identifier
-- sql_variant

---------------------------------------


-- switch case (print if the salary is high or low)
select ins_name, salary,
	case 
	when salary > 500000 then 'high'
	when salary < 500000 then 'low'
	else 'no value'
	end as newSal
from instructor 

-- easy way for if-else (no multiple conditions)
select ins_name, iif(salary > 500000, 'high', 'low')
from instructor

-- switch case with update statement (update all salaries based on condition)
update instructor 
set salary = 
	case 
	when salary > 500000 then salary*1.000001
	when salary < 500000 then salary * 1.002
	end


-- convert date to string 
select convert(varchar(20), getdate()) -- better cause we can use code as a third param for formats
select cast(getdate() as varchar(20))

select convert(varchar(20), getdate(), 102) -- format function is more easier (below)
select convert(varchar(20), getdate(), 103)
select convert(varchar(20), getdate(), 104)
select convert(varchar(20), getdate(), 105)

-- more easier
select format(getdate(), 'dd-MM-yyyy') -- 14-05-2025
select format(getdate(), 'dddd MMMM yyyy') -- Wednesday May 2025
select format(getdate(), 'ddd MMM yy') -- Wed May 25
select format(getdate(), 'dddd') -- Wednesday
select format(getdate(), 'MMM') -- May
select format(getdate(), 'hh:mm:ss') -- 11:57:33
select format(getdate(), 'HH') -- 24 format >> 23
select format(getdate(), 'hh tt') -- am, pm >> 11 PM
select format(getdate(), 'dd-MM-yyyy hh:mm:ss tt') -- 14-05-2025 11:58:30 PM
-- 'M' for month, 'm' for minute

select year(getdate())
select month(getdate())
select day(getdate()) -- return is 14 as int
select format(getdate(), 'dd') -- return is 14 as string
select format(eomonth(getdate()), 'dd') -- eomonth: end of month (last day in the current month) >> 31
select format(eomonth(getdate()), + 2) --  end of month after after this month (ex: current is august, get end of month for october)

-- math
select sqrt(25), abs(-4), sin(90), cos(90), tan(90)

select datediff(year, '1-1-2010', '1-1-2017') -- 7
select datediff(month, '1-1-2010', '1-1-2017') -- 84
select datediff(day, '1-1-2010', '1-1-2017') -- 2557
select datediff(week, '1-1-2010', '1-1-2017') -- 366

select OBJECT_ID('department') -- null: if department table doesn't exist or return number 

-- string 
select CHARINDEX('a', 'Mohammed') -- 4 ( 1 index based)
select CHARINDEX('x', 'mohamed') -- 0
select REPLACE('abdowahbah$gmail.com', '$', '@') -- abdowahbah@gmail.com
select stuff('ahmedOmarMohammed', 6, 4, 'Ali') -- replace from index 6 and for 4 letters with 'ali' >> ahmedAliMohammed
select std_Fname + SPACE(10) + std_Lname from student