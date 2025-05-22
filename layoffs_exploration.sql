SELECT year(`date`), sum(total_laid_off)
from layoffs_staging2
GROUP BY year(`date`)
order by 1;

-- Rolling Total Laid Off by MONTH
select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
ORDER BY `month` asc;

with rolling_total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
ORDER BY `month` asc
)
select `month`, total, sum(total) OVER(ORDER BY `month`) as rolling
from rolling_total;

-- Company by Date

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking TOP Company Laid Off

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Ranking AS
-- DOUBLE CTEs BABY!!
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as `rank`
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Ranking
Where `rank` <= 5;