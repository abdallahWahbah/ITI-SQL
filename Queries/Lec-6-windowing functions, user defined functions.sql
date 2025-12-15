------------------------------------------------------
-- windowing functions: (lead, lag, first_value, last_value), user-defined functions
------------------------------------------------------

-- split the degrees by course names then
-- display student name, grade, course name(for each course) and some columns showing for each student (row) the following:
-- 1- the student with grade less than him directly, 3- his name
-- 2- the student with grade greater than him directly, 4- his name
-- 5- best begree for each course
-- 6- worse degree for each course
select sname, grade, cname,
	prev_grade = LAG(grade) over (partition by cname order by grade), -- the student degree having degree less than him in the same course
	next_grade = LEAD(grade) over (partition by cname order by grade), -- the student degree having degree bigger than him in the same course
	prev_name = LAG(grade) over (partition by cname order by grade), -- the student name having degree less than him in the same course
	next_name = LEAD(grade) over (partition by cname order by grade), -- the student name having degree bigger than him in the same course
	worst_degree = FIRST_VALUE(grade) over (partition by cname order by grade), -- the worst degree in each course
	best_degree = LAST_VALUE(grade) over (partition by cname order by grade) -- the best degree in each course
	worst_student = FIRST_VALUE(sname) over (partition by cname order by grade), -- the worst student in each course
	best_student = FIRST_VALUE(sname) over (partition by cname order by grade), -- the best student in each course
from grades

-- continuing on the previous example, i want to display certain student 
select *
from(select sname, grade, cname,
	prev_grade = LAG(grade) over (partition by cname order by grade),
	next_grade = LEAD(grade) over (partition by cname order by grade),
	prev_name = LAG(grade) over (partition by cname order by grade),
	next_name = LEAD(grade) over (partition by cname order by grade)
	from grades) as newTable
where sname = 'ahmed' and cname='html'




------------------------------------------------------
-- scalar function: return one value
------------------------------------------------------
create function getStudentById(@sid int)
returns varchar(50)
	begin
		declare @name varchar(50)
			select @name = st_fname from Student where st_id=@sid
		return @name
	end

-- calling
select dbo.getStudentById(10) -- when calling scalar function, you must specify the schema (dbo.) cause it's a user-defined function, it will search for it in the built-in functions
select GETDATE() -- built-in function, no need for writing the schema
-- of course you can create new schema and move this function to the new schema and call it by the new schema




------------------------------------------------------
-- inline function: return table
------------------------------------------------------
-- take num of dept, return list of inst with their salaries, the salary is multiplied by 12
create function getInstructorsWithSalaries(@did int)
returns table
as 
	return (
		select Ins_Name, Salary * 12 as annualSalary
		from Instructor
		where Dept_Id = @did
	)

-- calling
select * from getInstructorsWithSalaries(10)
select ins_name from getInstructorsWithSalaries(10)
select sum(annualSalary) from getInstructorsWithSalaries(10)




------------------------------------------------------
-- multi: table with logic like if, while
------------------------------------------------------
-- get student first or last or full name based on a param (get the data from student table)
create function getStudentName(@format varchar(50))
returns @tableNew table(id int, sname varchar(50))
as
	begin
		if @format = 'first'
			insert into @tableNew
			select st_id, st_fname from Student
		else if @format = 'last'
			insert into @tableNew
			select st_id, st_lname from student
		else if @format = 'full'
			insert into @tableNew
			select st_id, concat(st_fname, ' ', st_lname) from student
		return -- only return keyword ... to force you return the type you specified (table)
	end

-- calling
select * from getStudentName('full')