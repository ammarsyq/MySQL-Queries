Select 
	employee_id,
    first_name,
    last_name,
    occupation,
    salary,
    department_name,
case
	when salary < 50000 then salary + (salary * 0.05)
	when salary > 50000 then salary + (salary * 0.07)
end as bonus_salary,
case
	when dept_id = 6 then salary * .1
end as bonus_fin
from employee_salary as sal
join parks_departments as dp
on sal.dept_id = dp.department_id
;

select gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;





-- Advance SQL
	-- CTEs

with exp_table as
(
Select
	gender,
    avg(salary),
    max(salary),
    min(salary),
    count(salary)
from employee_demographics dem
join employee_salary sal
 on dem.employee_id = sal.employee_id
group by gender
)
select *
from exp_table
;

	-- Temp Table

create temporary table temp_sal
select *
from employee_salary
where salary >= 50000;

select *
from temp_sal
;

	-- Stored Procedures
