delimiter ;
use stam;

select version();

create table if not exists student (
  sid integer auto_increment primary key, fname varchar(24), lname varchar(24) );
  
insert into student values (null, 'bezalel', 'bareli');
insert into student values (null, 'davira', 'bareli');
insert into student values (null, 'amit', 'bareli');


create table if not exists dept (
  did integer auto_increment primary key, name varchar(24) );  

insert into dept values (null, 'computers');
insert into dept values (null, 'biology');
insert into dept values (null, 'history');

    
create table if not exists course (
  cid integer auto_increment primary key, name varchar(24), 
  did integer,
  foreign key (did) references dept(did) );

insert into course values (null, 'ibm', 1);
insert into course values (null, 'c', 1);
insert into course values (null, 'java', 1);
insert into course values (null, 'js', 1);
insert into course values (null, 'cell stem', 2);
insert into course values (null, 'ligaments', 2);

create table if not exists student_schedule (
  sid integer, cid integer, date1 date, date2 date, grade integer,
  primary key (sid, cid),
  foreign key (sid) references student(sid),
  foreign key (cid) references course(cid) );

insert into student_schedule values (1, 1, '2019-01-01', '2019-06-30', 98);
insert into student_schedule values (1, 2, '2019-02-01', '2019-07-30', 96);


select C.name, D.name
from course as C
  right join dept as D
  on C.did = D.did;

select D.did, D.name, C.name
from dept as D
  left join course as C
  on D.did = C.did;


select count(C.name) as Courses, C.did
from course C
  left join dept D
  on C.did = D.did
where D.name = 'computers'
group by C.did
having Courses > 0;

select * from course as c1
where 2 = (
  select count(*) from course as c2
  where c1.cid = c2.cid
);

select count(*) Counter from course c1, course c2
where c1.cid = c2.cid
group by c1.cid
having Counter > 1;

select "Bezalel" regexp 'z';

call myversion();
create procedure myversion()
  select "1.0";

drop procedure student_info;
call student_info('bezalel', @result);
select @result;
delimiter $$
create procedure student_info(in _name varchar(24), out _result char(4))
begin
  select S.sid, S.fname, S.lname, C.name as 'Course Name', R.grade, D.name as 'Dept Name'
  from student as S
    left join student_schedule R
    on S.sid = R.sid
    left join course C
    on R.cid = C.cid
    left join dept D
    on C.did = D.did
  where fname like _name;
  
  set _result = 'OK';
end$$
