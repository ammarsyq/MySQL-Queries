-- Data Cleaning

select *
from layoffs
;
	-- Staging
CREATE TABLE layoffs_staging
like layoffs
;

insert layoffs_staging
select *
from layoffs
;

	-- Remove Duplicates

		-- CTEs
with duplicates as
(select *,
	row_number() over (partition by company, location, industry, total_laid_off, 
    percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_staging
)
select *
from duplicates
where row_num > 1
;

select *
from layoffs_staging2
where company = 'casper'
;
		-- Staging 2 for Removing Dupes (new tabl)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select *,
	row_number() over (partition by company, location, industry, total_laid_off, 
    percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_staging
;

		-- Removing Dupes in staging 2
delete 
from layoffs_staging2
where row_num > 1
;

select *
from layoffs_staging2
;

-- Standarization
	-- Trim company col
update layoffs_staging2
set company = trim(company)
;
	-- Distict Industry
    
select distinct(industry)
from layoffs_staging2
order by 1
;
		-- Update Crypto
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct(industry)
from layoffs_staging2
order by 1
;

select *
from layoffs_staging2
where location = 'Non-U.S.'
;

update layoffs_staging2
set location = 'Florianapolis'
where location ='FlorianÃ³polis'
;

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select *
from layoffs_staging2
where industry is null;

delete
from layoffs_staging2
where company = "Bally's Interactive";

delete
from layoffs_staging2
where total_laid_off is null
 and percentage_laid_off is null;
 
 select `date`, str_to_date(`date`, '%m/%d/%Y')
 from layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date(`date`, '%m/%d/%Y');
 
 alter table layoffs_staging2
 modify column `date` date;
 
 select *
 from layoffs_staging2;
 
 alter table layoffs_staging2
 drop column row_num;
 
 select distinct(country)
 from layoffs_staging2
 order by 1;
 
 update layoffs_staging2
 set country = 'United States'
 where country = 'United States.';