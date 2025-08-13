create table student(id int, name varchar(40), state varchar(40), city_pin int, gender char, Dob date);

select * from student order by id;

insert into student values
(101, 'falguni','Maharashrtra', 425460, 'm', '2003-10-03');

insert into student values
(102, 'neha','Mp', 423470, 'f', '2005-10-23'),
(103, 'punam','up', 423420, 'f', '2005-12-28'),
(106, 'nutan','MH', 434250, 'f', '2003-04-13'),
(109, 'naresh','gujrat', 678390, 'm', '2004-04-24');

update student set gender = 'f' where name = 'falguni';



