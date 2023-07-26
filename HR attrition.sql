Create Database projects ; 
Use projects;
Select * from hr ;


/*alteration of a column name*/
alter table hr 
change column ï»¿id emp_id varchar(20) Null;

describe hr;

select birthdate from hr;

set sql_safe_updates = 0;

update hr



set birthdate = Case
	When birthdate Like '%/%' Then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    When birthdate Like '%-%' Then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
	else null
End;		
	
select hire_date from hr;

Alter table hr
modify column birthdate date;	
describe hr;

set sql_safe_updates=0;
update hr

Set hire_date = Case
	When hire_date Like '%/%' Then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    When hire_date Like '%-%' Then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
	Else Null
End;

update hr


set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
	where termdate is not null and termdate!='';


alter table hr 
modify column hire_date date;

describe hr;




describe hr;

alter table hr 
add column age int;

describe hr;

select age from hr;

update hr

set age = timestampdiff(year,birthdate,curdate());





describe hr;


alter table hr 
modify column termdate date;

select min(age) as youngest , max(age) as eldest from hr;


alter table hr 
modify column termdate date;

-- Questions

-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count
from hr 
where age >= 18 and termdate = ''
group by gender;

-- 2. What is the age distribution of employees in the company?
select case
		when age>=18 and age <=24 then '18-24'
		when age>=25 and age <=34 then '25-34'
		when age>=35 and age <=44 then '35-44'
		when age>=45 and age <=54 then '45-54'
		else '55+'
	end as age_group,
    count(*)
from hr 
where age >= 18 and termdate = ''
group by age_group 
order by age_group ;

-- 3. What is the race/ethnicity of employees in the company?
select race, count(*) as count from hr where age >= 18 and termdate = '' group by race order by count desc ;

-- 4. How many employees work at the headquarters versus remote location?
select location, count(*) as count from hr where age >= 18 and termdate = '' group by location  ;

-- 5. What is the average length of employment for employees who have been terminated?
select 
	round(avg(datediff(termdate,hire_date))/365,0) as avg_len_employment
from hr
where termdate<= curdate() and termdate<> '' and age >=18;
    
-- 6. How does the gender distribution vary across the department and job titles?
select department, gender, count(*) as count from  hr where age >= 18 and termdate = '' group by department, gender ;

-- 7. What is the distribution of job titles across the company?
select jobtitle, count(*) as count from  hr where age >= 18 and termdate = '' group by jobtitle ;

-- 8. Which department has the highest turnover rate?
select department, total_count, terminated_count, (terminated_count/total_count)*100 as termination_rate
from (
	
    select department, count(*) as total_count, sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr where age >=18 group by department) as subquery
order by termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state?
select location_state, count(*) as count from hr where age >= 18 and termdate = '' group by location_state order by count desc; 

-- 10. What is the tenure distributions for each department?
select department, round(avg(datediff(termdate,hire_date))/365,0) from hr where age >= 18 and termdate <> '' and termdate <= curdate() group by department;



-- 11. How has the company's employee count changed over time based on hire and term dates?
Select
	year, hires, terminations, hires-terminations as net_change, round((hires-terminations)/hires*100,2) as net_percent_change
	from(
		select
			year(hire_date) as year, count(*) as hires,sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as terminations
			from hr where age >=18 group by Year) as subquery
order by year asc;



