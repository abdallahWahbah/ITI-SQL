CREATE TABLE student (
    std_id INT PRIMARY KEY,
    std_Fname VARCHAR(50),
    std_Lname VARCHAR(50),
    std_Address VARCHAR(100),
    std_Age INT,
    Dept_id INT,
    St_super VARCHAR(100),
);
CREATE TABLE dept (
    Dept_id INT PRIMARY KEY,
    Dept_Name VARCHAR(100),
    Dept_Desc VARCHAR(255),
    Dept_Location VARCHAR(100),
    Dept_Manager VARCHAR(100),
    Dept_HireDate DATE
);

INSERT INTO student (std_id, std_Fname, std_Lname, std_Address, std_Age, Dept_id, St_super) VALUES 
(101, 'Alice', 'Brown', '123 Elm St', 20, 1, 'Prof. Clark'),
(102, 'Bob', 'Smith', '456 Oak St', 22, 2, 'Prof. Alan'),
(103, 'Charlie', 'Davis', '789 Pine St', 21, 1, 'Prof. Clark'),
(104, 'Diana', 'Evans', '321 Maple St', 23, 3, 'Prof. Ray'),
(105, 'Eva', 'Williams', '654 Cedar St', 24, NULL, NULL),
(106, 'Frank', 'Moore', '987 Birch St', 20, NULL, 'Prof. Unknown')

INSERT INTO dept (Dept_id, Dept_Name, Dept_Desc, Dept_Location, Dept_Manager, Dept_HireDate) VALUES 
(1, 'Computer Science', 'Handles CS-related courses', 'Building A', 'Dr. Adams', '2020-08-15'),
(2, 'Mathematics', 'Math department', 'Building B', 'Dr. Newton', '2019-06-01'),
(3, 'Physics', 'Physics and Research', 'Building C', 'Dr. Feynman', '2018-09-10'),
(4, 'Chemistry', 'Chemical sciences department', 'Building D', NULL, NULL),
(5, 'History', 'Historical studies and research', 'Building E', NULL, NULL);



---------------------------------------
-- cross join (cartesian product)
---------------------------------------

select std_Fname, Dept_Name
from student, dept -- the same as >>> from student cross join dept



---------------------------------------
-- inner join (equi join)
---------------------------------------

select std_fname, dept_name
from Student s inner join dept d
on s.Dept_id = d.Dept_id

-- select each student with all information about the department he is in
select std_fname, d.*
from Student s inner join dept d
on s.Dept_id = d.Dept_id

-- select each student with all information about the department he is in >>> student in alex and order 
select std_fname, d.*
from Student s inner join dept d
on s.Dept_id = d.Dept_id and s.std_Address='123 Elm St'
order by d.Dept_Name



---------------------------------------
-- outer join 
---------------------------------------

-- left outer join: select all student whether they are in dept or not
select std_fname, dept_name
from student s left outer join dept d 
on s.dept_id = d.dept_id

-- right outer join: select all dept whether they have students not
select std_fname, dept_name
from student s right outer join dept d 
on s.dept_id = d.dept_id

-- full outer join: select all students and depts
select std_fname, dept_name
from student s full outer join dept d 
on s.dept_id = d.dept_id



---------------------------------------
-- self join: 2 copies from the same table
---------------------------------------

-- won't work cause chatgpt made st_super text not number
select X.std_Fname, Y.*
from student X, student Y
where y.std_id=x.St_super



---------------------------------------
-- join + update
---------------------------------------

update student set std_Age+=10
from student s, dept d
where s.Dept_id=d.Dept_id and s.std_Address='123 Elm St'



---------------------------------------
-- functions: isnull, coalesce, convert, concat, like
---------------------------------------

INSERT INTO student (std_id, std_Fname, std_Lname, std_Address, std_Age, Dept_id, St_super)
VALUES (107, NULL, 'Taylor', '135 Willow St', 22, 2, 'Prof. Alan');

select std_fname
from student
where std_fname is not null

-- isnull: replace null value with empty string or whatever you pass to it (during runtime)

-- replace null with string
select isnull(std_fname, 'has no name')
from student

-- replace null with another column value
select isnull(std_fname, std_Lname)
from student

-- replace null with the third value if the second one is null, and so on
select coalesce(std_fname, std_Lname, 'No Data')
from student

-- convert >> casting
select 'name: ' + std_fname + ', age: ' + convert(varchar(10), std_age)
from student

-- using convert with isnull (complex >>> use concat instead)
select 'name: ' + isnull(std_fname, 'no name') + ', age: ' + convert(varchar(10), isnull(std_age, 0))
from student

-- concat >>> convert anything to text and replace NULL with empty text
select concat(std_fname, ': ', std_age)
from student

-- concat with separator
select concat_ws(' & ', std_fname, ': ', std_age) -- abdallah & 12
from student


-- like (contains)
-- _ means one char
-- & means zero or more char
select *
from student
where std_fname like 'a%' -- start with a with any char number after 'a' 

-- a% start with a 
-- %a end with a 
-- %a% contains 'a' anywhere except beginning and end
-- _a% second letter is a 
-- a%h start with a, end with h
-- %a_ before end is a 
-- ____ word consisting of 4 letters
-- ____% >>>> 4 letters or more
-- _m__ >>> 4 letters and the second is m

-- ahm% strats with ahm
-- [ahm]%  starts with a or h or m 
-- [^ahm]% doesn't start with a neither h neither m
-- [a-h]% (range) >>> starts with (range) a or b .... h
-- [^a-h]% doesn't start with (range) a ... h
-- [346]% starts with 3 or 4 or 6
-- [(am)(gh)] groups >> start with am or gh
-- %[%] string ends with %
-- %[_]% contains _ >>>> ex: ahmed_ali
-- [_]%[_] start and end with _ >>> _ahmed_




-- sort the student by dept_id and when dept_id duplicates, sort by age
select std_fname, dept_id, std_age
from student
order by dept_id asc, std_age desc

