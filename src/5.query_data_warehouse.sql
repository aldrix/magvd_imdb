-- //-------------------------------------------------------------------//
-- //-----------  FREQUENT QUERIES IN DATA WAREHOUSE    ----------------//
-- //-------------------------------------------------------------------//

--  Actores cuyas películas han sido mejor valoradas
WITH actors_best  AS( SELECT DISTINCT  a.actor_id, a.primary_name, r.average_rating
FROM pro.fact_rating r
JOIN pro.dim_actors a ON a.actor_id = r.actor_id
JOIN pro.dim_titles t ON t.title_id = r.title_id
WHERE r.average_rating = (SELECT MAX(average_rating)
                          FROM pro.fact_rating r)
--GROUP BY  a.primary_name
ORDER BY  a.primary_name ASC
)
SELECT a.primary_name AS actor , a.average_rating
--      , MIN(r.average_rating), MAX(r.average_rating)
FROM  actors_best a
-- INNER JOIN pro.fact_rating r ON  r.actor_id = a.actor_id  and a.title_id != r.title_id
-- GROUP BY A.primary_name

;


SELECT DISTINCT  a.actor_id, a.primary_name, r.average_rating
FROM pro.fact_rating r
         JOIN pro.dim_actors a ON a.actor_id = r.actor_id
         JOIN pro.dim_titles t ON t.title_id = r.title_id
WHERE r.average_rating = (SELECT MAX(average_rating)
                          FROM pro.fact_rating r)
--GROUP BY  a.primary_name
ORDER BY  a.primary_name ASC;


--  Actores cuyas películas han sido mejor valoradas
SELECT average_rating
FROM pro.fact_rating r
WHERE average_rating = 10;

--  Actores cuyas películas han sido mejor valoradas
SELECT t.original_title, a.primary_name, MAX(average_rating)
FROM pro.fact_rating r
         JOIN pro.dim_actors a ON a.actor_id = r.actor_id
         JOIN pro.dim_titles t ON t.title_id = r.title_id
GROUP BY  t.original_title, a.primary_name
ORDER BY t.original_title ASC
;


SELECT r.actor_id
FROM pro.fact_rating r , pro.fact_rating r1
WHERE r.actor_id != r1.actor_id
and r.title_id !=

SELECT
    a.primary_name, a.birth_year, a.death_year, a.profession1,  count(*)
FROM pro.dim_actors a
GROUP BY
    a.primary_name, a.birth_year, a.death_year, a.profession1
HAVING count(*) > 1;

SELECT *
FROM pro.dim_actors WHERE primary_name LIKE '50 Cent';

-- 509041 son ft 22
-- 509042  son ft 22

with  aux as (
    SELECT *
    from pro.fact_rating r
    where r.actor_id = 509041
)SELECT COUNT(*) FROM aux ;



DELETE from pro.dim_actors where actor_id = 509042;

with  aux as (SELECT actor_id
FROM pro.dim_actors WHERE primary_name LIKE 'A.R. Rawlinson')
select * from  aux a
join pro.fact_rating r on r.actor_id = a.actor_id;

WITH aux AS  (SELECT DISTINCT a.primary_name, a.birth_year, a.death_year, a.profession1, a.profession2
FROM PRO.dim_actors a)
SELECT COUNT(*) FROM aux;
-- 1046914
-- 1080055

SELECT COUNT(*) FROM staging.dim_actors;
-- 1238033

-- Actores repetidos aproximadamente
-- 191119


-- Actores
-- 669422
-- 669423

Select  *
FROM pro.fact_rating r
WHERE r.actor_id in (669422, 669423);
