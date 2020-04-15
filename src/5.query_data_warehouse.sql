-- //-------------------------------------------------------------------//
-- //-----------  FREQUENT QUERIES IN DATA WAREHOUSE    ----------------//
-- //-------------------------------------------------------------------//
-- 1096607 1096883
SELECT COUNT(*) FROM pro.dim_actors;

-- 604162
SELECT COUNT(*) FROM pro.dim_directors;

-- 2246
SELECT COUNT(*) FROM pro.dim_genres;

-- 546318
SELECT COUNT(*) FROM pro.dim_titles;

SELECT COUNT(*) FROM pro.fact_rating;



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


