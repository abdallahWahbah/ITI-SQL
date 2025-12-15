------------------------------------------
-- Index, cursor, view, rollup
------------------------------------------

------------------------------------------
-- Index
------------------------------------------
-- you can find the index after executing the following quert at >>> click on the '+' sign beside the table, indexes
create NonClustered Index i1
on Student(St_Age)



------------------------------------------
-- Cursor: to deal with the data row by row >>> looping 
------------------------------------------

-- example: 1
-- display each name in one table
declare c1 cursor
for select st_id, st_fname
	from Student
	where St_Address = 'alex'
for read only  -- or for update (behavior)

declare @id int, @name varchar(20)
open c1
fetch c1 into @id, @name

while @@FETCH_STATUS = 0 
	begin
		select @id, @name
		fetch c1 into @id, @name -- as if we increasing the counter (get the next row)
	end
close c1
deallocate c1 


-- example: 2
-- we want the result to be one cell separated with commas >>> ahmed, amr, mona.....
-- we want to display all first names in the table in one cell separated with commas >>> ahmed, amr, mona.....
declare c1 cursor
for select st_fname 
	from Student
	where st_fname is not null
for read only

declare @name varchar(20), @allnames varchar(300) = ''
open c1
fetch c1 into @name
while @@FETCH_STATUS = 0
	begin
		set @allnames = concat(@allnames, ', ', @name)
		fetch c1 into @name
	end

select @allnames
close c1
deallocate c1


-- example: 3
-- cursor to update salaries
declare c1 cursor
for select salary 
	from Instructor
	where salary is not null
for update

declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS = 0
	begin
		if @sal <= 3000
			update Instructor set salary = @sal * 1.3
				where current of c1 -- at which the current cusror is pointing at (don't update the entire table)
		else 
			update Instructor set salary = @sal * 1.1
				where current of c1
		fetch c1 into @sal
	end
close c1
deallocate c1


-- example: 4 >>> get num of occurence for amr comming after ahmed in student table 
declare c1 cursor
for select st_fname
	from Student
	where St_Fname is not null
for read only

declare @name varchar(20), @flag int = 0, @counter int = 0
open c1
fetch c1 into @name
while @@FETCH_STATUS = 0
	begin
		if @name = 'ahmed' 
			set @flag = 1			
		fetch c1 into @name
		if @name = 'amr' and @flag = 1
			begin
				set @counter += 1
				set @flag = 0
			end
		else
			set @flag = 0
	end
select @counter
close c1
deallocate c1



------------------------------------------
-- View
------------------------------------------
-- creation
-- standard view
Create view ViewAlexStudents
with encryption -- to encrypt the code by which the view in created
as
select * from Student where St_Address = 'Alex'

create view ViewCairoStudents
with encryption
as
select * 
	from Student 
	where St_Address = 'cairo'
	with check option -- to prevent the user from inserting anything in the address except 'cairo' (match with where)


-- partitioned view (using union)
create view ViewAlexCairoStudents
with encryption
as 
select 
	st_id as sid,  -- using alias name to hide metadata from application programmer
	st_fname as sfname, 
	st_lname as slname, 
	St_Address as saddress 
	from ViewAlexStudents
union all
select 
	st_id as sid, 
	st_fname as sfname, 
	st_lname as slname, 
	St_Address as saddress 
	from ViewCairoStudents

create view vjoin
with encryption
as
select s.st_id as sid, s.St_Fname as sfname, d.Dept_Name as dname, d.Dept_Id as did
	from Student s inner join Department d
	on s.Dept_Id = d.Dept_Id


-- usage
select * from ViewAlexStudents
select sid, sfname, slname, saddress from ViewAlexCairoStudents


------- DML + view will affect the original table not the view
------- DML (insert, update, delete) + view consisting of (((one table))) 
insert into ViewAlexStudents values(1, 'abdallah', 'mahmoud') -- considering the view has 3 columns only, the rest of the columns in the original table must allow null (or) have defualt value (or) identity (auto increment) (or) driven column
-- insert into ViewCairoStudents(1, 'mahmoud', 'alex') -- will give error: accepting only cairo


------- DML(insert, update, noooooo delete) + view consisting of (((multi tables)))
-- insert or update: insert row to only one table
insert into vjoin (sid, sfname) values(53, 'ali')
insert into vjoin (did, dname) values(90, 'dentist')


-- more queries (don't run)
alter schema hr transfer vjoin
drop schema hr
drop view ViewAlexStudents


------------------------------------------
-- rollup
------------------------------------------
-- get the sum of quantities for each product, also print in the last row the total sum of all product (use rollup)
select productId, sum(quantity)
from sales
group by rollup(productId) -- roolup: to get the total sum for all products quantities in a new row after each product quantities

-- also refer to screenshot #333, #334
select productId, sum(quantity)
from sales
group by rollup(productId, salesmanName) -- will make rollup for each productid

