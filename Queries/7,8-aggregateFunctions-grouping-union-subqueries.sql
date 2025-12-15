------------ please select master from databases dropdown >>> working on dbo.instructor
select salary from instructor


---------------------------------------
-- aggregare functions: sum, min, max, count, avg
---------------------------------------
select sum(salary) as sum_salary, min(salary) as min_salary, max(salary) as max_salary, count(ins_id) as ins_count, avg(salary) as average
from instructor



---------------------------------------
-- group by
---------------------------------------

-- get sum of salaries in each department (will not work well cause all salaries in the table are null)
select sum(salary), dept_id
from Instructor
group by dept_id

-- get sum of salaries and dept_id where count of instructors in the dept < 6
select sum(salary), dept_id
from instructor
group by dept_id
having count(ins_id) < 6

-- get sum of salaries in each department for instructors with salary > 10000 and num of instructor < 6
select sum(salary), dept_id
from instructor
where salary > 100000 -- where is performed on rows
group by dept_id
having count(ins_id)<6 -- having is performed on groups (aggregate functions)
-- aggregate functions work with having not where



-- (not important) get count with combination of (grouping) address and department >> example: department num 10 in cairo, 20 in mansoura
select count(st_id), st_address, dept_id
from student
group by st_address, dept_id






---------------------------------------
-- Subqueries: take output of query as input to another query
---------------------------------------

select avg(salary) from instructor -- 408666

-- get details of students where student age is less than the average
select * from student
where st_age < (select avg(st_age) from student)

-- select all instructors that have salary above the average
select * from instructor
where salary > (select avg(salary) from instructor) -- where salary > 408666


-- example out of my database (don't run it, just read the logic)
-- get all departement names that have students
select dept_name 
from Department
where dept_id in (select distinct dept_id 
					from Student
					where dept_id is not null)
-- the same as using (inner join) below (better for performance)
select distinct dept_name
from Department d inner join Student s
where d.dept_id = s.dept_id

-- subquery + DML
delete from instructor where ins_id = 1 -- easy

-- don't run it >>> delete all instructors with Master degree
delete from instructor 
where ins_degree in (select ins_degree from instructor where ins_degree='Master')
-- delete students from cairo
delete from Student
where std_id in (select std_id from Student where std_address='cairo')



---------------------------------------
-- union family: union all, union, intersect, except

-- union all: get all data from different tables and put them above each other
-- union: (order + unique) the same as 'union all' but remove duplicates (distinct)
-- intersect: common between diferrent dataset >>> in first select and in the second select (both)
-- except: get data in first dataset and doesn't exist in the second dataset
---------------------------------------

select std_name from Student
union all
select ins_name from instructor



-- external example
select std_fname, st_age, dept_id
from student
order by 1 -- order by first column in the select statement (std_fname)


select std_fname, st_age, dept_id
from student
order by dept_id asc, std_ge desc -- order by dept_id and when multiple students have the same dept_id ascending, order by age descinding
 



 -- some built in functions
 -- aggregate, isnull, coalesce, convert, concat, getdate
select year(getdate())
-- select year(getdate()) - year(birthYearInTable)
select month(getdate())
select db_name()
select SUSER_NAME() -- window user (AbdallahWahbah\abdowahbah)
select upper(fname), lower(fname), len(fname) from Student -- lowercase, uppercase, length of the string
select substring(std_fname, 1, 3) from student -- get first 3 letters from all names (starting index = 1) >>> ahmed to be ahm
select SUBSTRING(std_fname, 1, len(std_fname) - 1) -- all letters except the last one














