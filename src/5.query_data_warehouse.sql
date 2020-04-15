-- //-------------------------------------------------------------------//
-- //-----------  FREQUENT QUERIES IN DATA WAREHOUSE    ----------------//
-- //-------------------------------------------------------------------//
--  Actores cuyas películas han sido
--  los actores cuyas películas
--  han sido mejor valoradas junto con la calificación media de sus películas
WITH actors_best  AS( SELECT DISTINCT  a.actor_id, a.primary_name, r.average_rating, r.num_votes
                      FROM pro.fact_rating r
                               JOIN pro.dim_actors a ON a.actor_id = r.actor_id
                      WHERE r.average_rating = (SELECT MAX(average_rating)
                                                FROM pro.fact_rating r)
                      ORDER BY  a.primary_name ASC
)
SELECT a.primary_name AS actor , SUM(a.average_rating * a.num_votes)/SUM(num_votes)
FROM  actors_best a
GROUP BY a.primary_name
ORDER BY a.primary_name ASC
;


-- las películas más votadas por los usuarios indicando el número de votos recibidos
-- y la puntuación media
SELECT  t.original_title, r.num_votes,  SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pro.fact_rating r
         JOIN pro.dim_titles t ON t.title_id = r.title_id
GROUP BY  t.original_title, r.num_votes
ORDER BY r.num_votes DESC
LIMIT  10;


-- la media de puntuaciones por género1
SELECT  t.genres1,  SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pro.fact_rating r
         JOIN pro.dim_genres t ON t.genres_id = r.r.genres_id
GROUP BY  t.genres1
ORDER BY puntuación_media DESC
LIMIT  10;


-- el número de películas de cada género1 estrenadas en un periodo determinado
SELECT  t.genres1,  t.release_year, count(t.title_id)
FROM pro.fact_rating r
         JOIN pro.dim_genres t ON t.genres_id = r.r.genres_id
         JOIN pro.dim_titles t ON t.title_id = r.title_id
WHERE t.release_year is not  null
GROUP BY  t.genres1,  t.release_year
ORDER BY t.release_year DESC
LIMIT  10;


-- JOIN pro.dim_titles t ON t.title_id = r.title_id
-- INNER JOIN pro.fact_rating r ON  r.actor_id = a.actor_id  and a.title_id != r.title_id
-- GROUP BY A.primary_name
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
and r.title_id ;

drop view  dup_actor;
CREATE  TEMP  VIEW  dup_actor as (SELECT
    a.primary_name, a.birth_year, a.death_year, a.profession1, MIN(a.actor_id) as id ,  count(*)
FROM pro.dim_actors a
GROUP BY
    a.primary_name, a.birth_year, a.death_year, a.profession1
HAVING count(*) > 1);


select count(*) from dup_actor;
-- 95796






-- DELETE from pro.dim_actors where actor_id in (
    SELECT actor_id
    FROM pro.dim_actors a
             join dup_actor d on a.primary_name = d.primary_name and  a.birth_year = d.birth_year and
                                 a.death_year = d.death_year and  a.profession1 = d.profession1 and
                                 a.actor_id != d.id
                                 );



with dup as (SELECT actor_id
FROM pro.dim_actors a
join dup_actor d on a.primary_name = d.primary_name and  a.birth_year = d.birth_year and
                    a.death_year = d.death_year and  a.profession1 = d.profession1 and
                    a.actor_id != d.id
    )select count(*)
from dup;





SELECT
    a.primary_name, a.birth_year, a.death_year, a.profession1, Min(a.actor_id) as id,  count(*)
FROM pro.dim_actors a
WHERE a.actor_id not in (select id from dup_actor)
GROUP BY
    a.primary_name, a.birth_year, a.death_year, a.profession1
HAVING count(*) > 1;








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
    where r.actor_id = 509042
)SELECT COUNT(*) FROM aux;














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
