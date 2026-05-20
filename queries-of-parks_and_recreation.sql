#Group employees by age and display:age
SELECT 
    age,
    COUNT(*) AS total_employees,
    ROUND(AVG(sal.salary), 1) AS avg_salary
FROM
    employee_salary AS sal
        JOIN
    employee_demographics AS dem ON sal.employee_id = dem.employee_id
WHERE
    sal.salary >= 65000
GROUP BY age
ORDER BY avg_salary DESC
;


#Display departments whose average salary is higher than the overall company average salary.
SELECT department_id,
    department_name, ROUND(AVG(sal.salary), 0) AS salary
FROM
    employee_salary AS sal right join parks_departments as park on sal.dept_id = park.department_id
    WHERE salary > (
    SELECT AVG(salary)
    FROM employee_salary
)
GROUP BY department_id

;


#Show the highest-paid employee in each department.
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.salary,
    e.dept_id
FROM 
    employee_salary e
INNER JOIN (
    SELECT 
        dept_id, 
        MAX(salary) AS highest
    FROM 
        employee_salary
    GROUP BY dept_id
) AS sub 
ON e.dept_id = sub.dept_id AND e.salary = sub.highest;

#Sort alphabetically by last name.
SELECT 
    CONCAT(dem.last_name, ', ', dem.first_name) AS employee_name,
    age,
    salary
FROM
    employee_demographics AS dem
        JOIN
    employee_salary AS sal ON dem.last_name = sal.last_name
ORDER BY employee_name ASC;




#Employees Earning Above Their Department Average          
 SELECT 
    e1.dept_id, 
    CONCAT(first_name, ' ', last_name) AS employee_name, 
    salary
FROM 
    employee_salary e1
WHERE 
    salary > (
        SELECT AVG(salary) 
        FROM employee_salary e2 
        WHERE e2.dept_id = e1.dept_id
    ); 
    
    
#count the total employees role "office manager" and salary above than avarage salary 
select occupation ,count(*) as total_employees, round(avg(salary),0) as avg_salary
		from employee_salary
        where occupation = 'Office Manager'
         group  by occupation
 ;


        


# get the average salary per department alongside the employee names,occupation
SELECT dept_id,fullname, avg_salary,occupation
FROM (
    SELECT 
        CONCAT(first_name, ' ', last_name) AS fullname,
        dept_id ,occupation ,
        AVG(salary) AS avg_salary
    FROM employee_salary
    WHERE salary > (SELECT AVG(salary) FROM employee_salary)
    GROUP BY dept_id, first_name, last_name,occupation
) AS subq
ORDER BY dept_id;




# get the average salary per department alongside the employee names,occupation
SELECT 
    dept_id, fullname, avg_salary, occupation
FROM
    (SELECT 
        dept_id,
            CONCAT(last_name, ', ', first_name) AS fullname,
            occupation,
            round(AVG(salary),0) AS avg_salary
    FROM
        employee_salary
    WHERE
        dept_id IS NOT NULL
            AND salary > (SELECT 
                AVG(salary)
            FROM
                employee_salary)
    GROUP BY dept_id , fullname , occupation) AS subq
    order by fullname;




#Common Table Expressionn excercise 'CTE'
with  salary_cte as (SELECT 
        CONCAT(first_name, ' ', last_name) AS fullname,
        dept_id ,occupation ,
        AVG(salary) AS avg_salary
    FROM employee_salary
    WHERE salary > (SELECT AVG(salary) FROM employee_salary)
    group by fullname, dept_id,occupation
    )
    
select fullname,dept_id,avg_salary from salary_cte;


#create temporary table
create temporary table avg_salary2(
	select concat(first_name,' ',last_name) fullname, dept_id,avg(salary) from employee_salary
    where salary > (select avg(salary) from employee_salary)
    group by dept_id,fullname);
        
select * from avg_salary2;


#create procedure table without parameter
delimiter $$
create procedure max_salary()
begin
	select dept_id,max(salary)
    from employee_salary
    where salary >= (select max(salary) from employee_salary)
    group by dept_id;
end $$
delimiter ;

call max_salary();

#create procedure table with parameter
delimiter $$
CREATE PROCEDURE max_salary2(param_dept_id int)
begin
	select dept_id,max(salary)
    from employee_salary
    where salary <= (select max(salary) from employee_salary) and dept_id = param_dept_id
    group by dept_id;
end
delimiter ;

call max_salary2(1);


#create events
delimiter $$
create event delete_retirees
on schedule every 30 second #every day, year, month
do 
begin
 delete 
 from employee_demographics
 where age >= 60;
 end $$
 delimiter ;
 
 select * from employee_demographics;
