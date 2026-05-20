-- cleaning data

select * from layoffs;

-- removing the duplicates

#creating table a copy table
create table copy_layoffs
like layoffs;

#inserting all the values like layoffs
insert copy_layoffs
select * from layoffs;

#look for the duplicates row
select *,row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,stage,country,funds_raised_millions) as row_num 
from copy_layoffs;



#cte
with cte_duplicates as (select *,row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,stage,country,funds_raised_millions,`date`) as row_num 
from copy_layoffs)

select *
from cte_duplicates
where row_num > 1;

#creating a copy table to remove the duplicates
CREATE TABLE `copy_layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from copy_layoffs2;

insert into copy_layoffs2
select *,row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from copy_layoffs;

#delete the duplicates
delete from copy_layoffs2
where row_num > 1;


select * from copy_layoffs2
where row_num >1;

-- Standardizing data
-- trim
update copy_layoffs2
set company = trim(company);

-- removing dots
update copy_layoffs2
set country = trim(trailing '.' from country)
where industry like 'United States%';

select country from copy_layoffs2
order by 1;

-- formating date
update copy_layoffs2
set `date` = str_to_date(`date`,'%m/%d/%Y');

-- modify the data type
alter table copy_layoffs2
modify column `date` DATE;

-- checking for null values
select * from copy_layoffs2
where total_laid_off is null
and percentage_laid_off is null;

-- setting the blank into null values
update copy_layoffs
set industry = NULL
where industry = '';

-- updating the null values with real values on industry'airbnb'
UPDATE copy_layoffs t1
        JOIN
    copy_layoffs2 t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    t1.industry is NULL
        AND t2.industry IS NOT NULL;
 
 -- deleting the null values
delete
from copy_layoffs2
where total_laid_off is null
and percentage_laid_off is null;

-- drop the unessesary column
alter table copy_layoffs2
drop column row_num;

select * from copy_layoffs2;