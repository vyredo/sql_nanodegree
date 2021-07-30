CREATE OR REPLACE VIEW forestation AS (
SELECT  f.country_name
       ,f.country_code
       ,f.year
       ,f.forest_area_sqkm
       ,l.total_area_sq_mi*2.58999                                       AS total_area_sqkm
       ,ROUND((f.forest_area_sqkm/(l.total_area_sq_mi*2.58999)) * 100,2) AS forest_pctg_area
	   ,r.region
FROM forest_area f
JOIN land_area l
ON f.year = l.year 
    AND f.country_code = l.country_code 
JOIN regions r
ON  f.country_code = r.country_code 
ORDER BY 6 DESC );


-- What was the total forest area （in sq km） of the world IN 1990
SELECT  forest_area_sqkm
FROM forestation
WHERE country_name = 'World' 
AND year = 1990;

-- What was the total forest area （in sq km） of the world IN 2016? 
SELECT  forest_area_sqkm
FROM forestation
WHERE country_name = 'World' 
AND year = 2016;

-- What was the change （in sq km） IN the forest area of the world  FROM 1990 to 2016?
SELECT  forest_2016.f_area - forest_1990.f_area AS change_1990_2016
FROM 
    (
        SELECT  forest_area_sqkm f_area
            ,country_code cc
        FROM forestation
        WHERE country_name = 'World' 
        AND year = 2016 
    ) AS forest_2016
JOIN 
    (
        SELECT  forest_area_sqkm f_area
            ,country_code cc
        FROM forestation
        WHERE country_name = 'World' 
        AND year = 1990 
    ) AS forest_1990
ON forest_1990.cc = forest_2016.cc;

-- What was the percent change IN forest area of the world BETWEEN 1990 AND 2016?
SELECT  ROUND(((forest_2016.f_area - forest_1990.f_area)/forest_1990.f_area)*100,2) AS pctg_change_1990_2016
FROM 
    (
        SELECT  forest_area_sqkm f_area
            ,country_code cc
        FROM forestation
        WHERE country_name = 'World' 
        AND year = 2016 
    ) forest_2016
JOIN 
    (
        SELECT  forest_area_sqkm f_area
            ,country_code cc
        FROM forestation
        WHERE country_name = 'World' 
        AND year = 1990 
    ) AS forest_1990
ON forest_1990.cc = forest_2016.cc;

-- If you compare the amount of forest area lost BETWEEN 1990 AND 2016
-- to which country's total area IN 2016 is it closest to? （Peru） 
WITH world_change AS 
        (
            SELECT  ABS(forest_2016.f_area - forest_1990.f_area) AS f_area
            FROM 
                (
                    SELECT  forest_area_sqkm f_area
                        ,country_code cc
                    FROM forestation
                    WHERE country_name = 'World' 
                    AND year = 2016 
                ) forest_2016
            JOIN 
                (
                    SELECT  forest_area_sqkm f_area
                        ,country_code cc
                    FROM forestation
                    WHERE country_name = 'World' 
                    AND year = 1990 
                ) AS forest_1990
            ON forest_1990.cc = forest_2016.cc
        ), 
    ta_2016 AS
        (
            SELECT  country_name
                ,total_area_sqkm
            FROM forestation
            WHERE year = 2016  
        )
SELECT  country_name
       ,total_area_sqkm
       ,(
            SELECT  f_area
            FROM world_change
        )
FROM ta_2016
ORDER BY (ABS(total_area_sqkm - (
                                    SELECT  f_area
                                    FROM world_change
                                )))
LIMIT 1;

-- ============================== 2. REGIONAL OUTLOOK =======================

-- What was the percent forest of the entire world IN 2016? 
SELECT  ROUND((f.forest_area_sqkm/f.total_area_sqkm) * 100,2) AS pctg_forest_area_2016
FROM forestation f
WHERE country_name = 'World' 
      AND f.year = 2016; 

--    Which REGION had the HIGHEST percent forest IN 2016, AND which had the LOWEST, to 2 decimal places? 
WITH region_area AS (
			SELECT  
				r.region,
				f.year,
				SUM(f.forest_area_sqkm) f_area,
				SUM(f.total_area_sqkm) l_area
			FROM forestation f
			JOIN regions r
			ON r.country_name = f.country_name
			GROUP BY 1,2
			HAVING 
				SUM(f.forest_area_sqkm) IS NOT NULL 
				OR SUM(f.total_area_sqkm) IS NOT NULL 
	)
SELECT 
	ra.region, 
	ra.year,
	(ra.f_area/ra.l_area) * 100 AS pctg_forest
FROM region_area ra
WHERE 
	ra.year = 2016 
	AND NOT region  = 'World'
ORDER BY 3 DESC 
LIMIT 1;

-- lowest percent forest in 2016
WITH region_area AS (
			SELECT  
				r.region,
				f.year,
				SUM(f.forest_area_sqkm) f_area,
				SUM(f.total_area_sqkm) l_area
			FROM forestation f
			JOIN regions r
			ON r.country_name = f.country_name
			GROUP BY 1,2
			HAVING 
				SUM(f.forest_area_sqkm) IS NOT NULL 
				OR SUM(f.total_area_sqkm) IS NOT NULL 
	)
SELECT 
	ra.region, 
	ra.year,
	(ra.f_area/ra.l_area) * 100 AS pctg_forest
FROM region_area ra
WHERE 
	ra.year = 2016 
	AND NOT region  = 'World'
ORDER BY 3 ASC 
LIMIT 1;

-- b. What was the percent forest of the entire world IN 1990? 
SELECT  
    ROUND((f.forest_area_sqkm/f.total_area_sqkm) * 100,2) AS pctg_forest_area_2016
FROM forestation f
WHERE 
    country_name = 'World' 
    AND f.year = 1990; 

-- Which region had the HIGHEST percent forest IN 1990, AND which had the LOWEST, to 2 decimal places? 
WITH region_area AS (
        SELECT  
            r.region,
            f.year,
            SUM(f.forest_area_sqkm) f_area,
            SUM(f.total_area_sqkm) l_area
        FROM forestation f
        JOIN regions r
        ON r.country_name = f.country_name
        GROUP BY 1,2
        HAVING 
            SUM(f.forest_area_sqkm) IS NOT NULL 
            OR SUM(f.total_area_sqkm) IS NOT NULL 
	)
SELECT 
	ra.region, 
	ra.year,
	(ra.f_area/ra.l_area) * 100 AS pctg_forest
FROM region_area ra
WHERE 
	ra.year = 1990 
	AND NOT region  = 'World'
ORDER BY 3 DESC 
LIMIT 1;
	

-- lowest percent forest in 1990
WITH region_area AS (
        SELECT  
            r.region,
            f.year,
            SUM(f.forest_area_sqkm) f_area,
            SUM(f.total_area_sqkm) l_area
        FROM forestation f
        JOIN regions r
        ON r.country_name = f.country_name
        GROUP BY 1,2
        HAVING 
            SUM(f.forest_area_sqkm) IS NOT NULL 
            OR SUM(f.total_area_sqkm) IS NOT NULL 
	)
SELECT 
	ra.region, 
	ra.year,
	(ra.f_area/ra.l_area) * 100 AS pctg_forest
FROM region_area ra
WHERE 
	ra.year = 1990 
	AND NOT region  = 'World'
ORDER BY 3 ASC 
LIMIT 1;


-- Based ON the TABLE you created, which regions of the world DECREASED IN forest area FROM 1990 to 2016?
WITH region_area AS 
        (
            SELECT  r.region
                ,f.year
                ,SUM(f.forest_area_sqkm) f_area
                ,SUM(f.total_area_sqkm) l_area
            FROM forestation f
            JOIN regions r
            ON r.country_name = f.country_name
            GROUP BY  1
                    ,2
            HAVING SUM(f.forest_area_sqkm) IS NOT NULL AND f.year = 1990 OR f.year = 2016 
        ),
     f_area_1990 AS 
        (
            SELECT  ra.region
                ,ra.year
                ,ra.f_area
            FROM region_area ra
            WHERE NOT region = 'World' 
            AND ra.year = 1990
            ORDER BY 3 ASC  
        ), 
    f_area_2016 AS 
        (
            SELECT  ra.region
                ,ra.year
                ,ra.f_area
            FROM region_area ra
            WHERE NOT region = 'World' 
            AND ra.year = 2016
            ORDER BY 3 ASC  
        )
SELECT  f_area_2016.region
       ,f_area_2016.f_area - f_area_1990.f_area AS forest_region_change
FROM f_area_2016
JOIN f_area_1990
ON f_area_1990.region = f_area_2016.region
WHERE 
    f_area_2016.f_area - f_area_1990.f_area < 0; 


-- Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?


SELECT  
    forest_1990.cn AS "country_name"
    ,forest_2016.f_area - forest_1990.f_area AS "Forest Area Change 1990-2016"
FROM 
    (
        SELECT  forest_area_sqkm f_area 
            ,country_name cn
        FROM forestation
        WHERE NOT country_name = 'World' 
        AND year = 2016  
    ) forest_2016
JOIN 
    (
        SELECT  forest_area_sqkm f_area 
            ,country_name cn
        FROM forestation
        WHERE NOT country_name = 'World' 
        AND year = 1990  
    ) AS forest_1990
ON forest_1990.cn = forest_2016.cn
ORDER BY 2
LIMIT 5;
	


-- b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? 
-- What was the percent change to 2 decimal places for each?

SELECT  
	forest_1990.cn AS "country_name" 
	,forest_2016.forest_pctg_area - forest_1990.forest_pctg_area AS "Forest Percentage change 1990 - 2016"
FROM 
    (
        SELECT  
            forest_pctg_area
            ,country_name cn
        FROM forestation
        WHERE 
            NOT country_name = 'World' 
            AND year = 2016 
			AND forest_pctg_area IS NOT NULL
    ) forest_2016
JOIN 
    (
        SELECT  
            forest_pctg_area
            ,country_name cn
        FROM forestation
        WHERE 
            NOT country_name = 'World' 
            AND year = 1990 
			AND forest_pctg_area IS NOT NULL
    ) AS forest_1990
ON forest_1990.cn = forest_2016.cn
WHERE 
	forest_2016.forest_pctg_area - forest_1990.forest_pctg_area IS NOT null
ORDER BY 2 ;


-- c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
WITH forest_pctg_area AS (
	SELECT 
		f.country_name,
		f.forest_pctg_area,
		CASE WHEN f.forest_pctg_area <= 25 THEN 1
		    WHEN f.forest_pctg_area > 25 AND f.forest_pctg_area <= 50 THEN 2
		    WHEN f.forest_pctg_area > 50 AND f.forest_pctg_area <= 75 THEN 3
		    ELSE 4 END AS "quartile_group"
	FROM 
		forestation f
	WHERE  
		f.year = 2016 
		AND f.forest_pctg_area IS NOT NULL
)
SELECT
	fpa.quartile_group,
	count(*)
FROM forest_pctg_area fpa
GROUP BY 1;

-- d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
WITH forest_pctg_area AS (
	SELECT 
		f.country_name,
		f.forest_pctg_area,
		CASE WHEN f.forest_pctg_area <= 25 THEN 1
		    WHEN f.forest_pctg_area > 25 AND f.forest_pctg_area <= 50 THEN 2
		    WHEN f.forest_pctg_area > 50 AND f.forest_pctg_area <= 75 THEN 3
		    ELSE 4 END AS "quartile_group"
	FROM 
		forestation f
	WHERE  
		f.year = 2016 
		AND f.forest_pctg_area IS NOT NULL
)
SELECT fpa.country_name
FROM forest_pctg_area fpa
WHERE fpa.quartile_group = 4;

-- e. How many countries had a percent forestation higher than the United States in 2016?
WITH us_forest_pctg AS (

		SELECT  f.country_name, 
				f.year,
				f.forest_pctg_area
		FROM forestation f
		WHERE 
			f.country_name = 'United States'
			AND year = 2016
	),
	countries_higher_than_us AS (
		SELECT 
			f.country_name, 
			f.forest_pctg_area
		FROM forestation f
		JOIN us_forest_pctg
		ON us_forest_pctg.year = f.year
		WHERE 
			f.year = 2016 
			AND f.forest_pctg_area IS NOT NULL
			AND f.forest_pctg_area > us_forest_pctg.forest_pctg_area
	)
SELECT COUNT(*) AS "Countries with percentage forest higher than USA in 2016"
FROM countries_higher_than_us;
