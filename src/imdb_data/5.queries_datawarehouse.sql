-- //-------------------------------------------------------------------//
-- //-----------  FREQUENT QUERIES IN DATA WAREHOUSE    ----------------//
-- //-------------------------------------------------------------------//
-- 589847
SELECT COUNT(*) FROM pro.dim_actors;

-- 205019
SELECT COUNT(*) FROM pro.dim_directors;

-- 2246
SELECT COUNT(*) FROM pro.dim_genres;

-- 547688
SELECT COUNT(*) FROM pro.dim_titles;

-- 3312406
SELECT COUNT(*) FROM pro.fact_rating;


-- //-------------------------------------------------------------------//
-- QUERY 1
--  Actores cuyas películas han sido
--  mejor valoradas junto con la calificación media de sus películas
WITH best  AS( SELECT  a.primary_name, a.actor_id, r.average_rating
               FROM pro.fact_rating r
                        JOIN pro.dim_actors a ON a.actor_id = r.actor_id
               WHERE a.primary_name != 'Unknown' and r.average_rating != 0
                GROUP BY a.primary_name, a.actor_id, r.average_rating
               ORDER BY  r.average_rating DESC
)
SELECT  a.primary_name AS actor , SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS calificacion_media
FROM  best a
LEFT JOIN pro.fact_rating r ON a.actor_id = r.actor_id
WHERE r.average_rating != 0
GROUP BY a.actor_id, a.primary_name, a.actor_id
ORDER BY calificacion_media DESC
-- LIMIT 200  -- Indicar el numero de actors
;


-- //-------------------------------------------------------------------//
-- QUERY 2
-- Las películas más votadas por los usuarios indicando el número de votos recibidos
-- y la puntuación media
SELECT  t.original_title, r.num_votes,  SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pro.fact_rating r
         JOIN pro.dim_titles t ON t.title_id = r.title_id
WHERE num_votes != 0
GROUP BY  t.original_title, r.num_votes
ORDER BY r.num_votes DESC
-- LIMIT  10
;

-- //-------------------------------------------------------------------//
-- QUERY 3
-- La media de puntuaciones por género

-- I Consideramos todos los generos de la pelicula
SELECT  t.genres, SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media, count(t.genres)
FROM pro.fact_rating r
         JOIN pro.dim_genres t ON t.genres_id = r.genres_id
WHERE num_votes != 0
GROUP BY  t.genres
ORDER BY puntuación_media  DESC
;

-- II Consideramos solo el genero principal
SELECT  t.genres1, SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media, count(t.genres)
FROM pro.fact_rating r
         JOIN pro.dim_genres t ON t.genres_id = r.genres_id
WHERE num_votes != 0
GROUP BY  t.genres1
ORDER BY puntuación_media  DESC
-- LIMIT  10
;

-- //-------------------------------------------------------------------//
-- QUERY 4
-- El número de películas de cada género estrenadas en un periodo determinado
SELECT  t.genres1, tt.release_year, count(tt.title_id) as movie_totals
FROM pro.fact_rating r
         JOIN pro.dim_genres t ON t.genres_id = r.genres_id
         JOIN PRO.dim_titles tt ON tt.title_id = r.title_id
WHERE num_votes != 0 and tt.release_year is not null
GROUP BY  t.genres1, tt.release_year
ORDER BY movie_totals  DESC
;



