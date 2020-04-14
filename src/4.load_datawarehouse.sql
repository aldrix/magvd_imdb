--/---------------------------------------------------------/
--/------------- CREATE TABLES FACT TABLE  -----------------/
--/---------------------------------------------------------/
-- DROP TABLE staging.fact_rating;

-- First approach to fill fact table in staging
CREATE TABLE staging.fact_rating AS (
    SELECT DISTINCT
        title_id
        ,CASE  WHEN genres_id IS NULL
               THEN 2246
           ELSE genres_id
        END
        ,a.actor_id
        ,d.director_id
        ,w.writer_id
        ,CASE  WHEN r.averagerating IS NULL
               THEN 0
           ELSE r.averagerating
        END  AS average_rating
        ,CASE  WHEN r.numvotes IS NULL
               THEN 0
           ELSE r.numvotes
        END  AS num_votes
        ,t.idpelicula
        FROM staging.dim_titles t
        LEFT JOIN "title.ratings" r ON t.idpelicula = r.tconst
        LEFT JOIN staging.dim_genres g ON g.genres_all = t.genres
        LEFT JOIN "title.principals" p ON p.tconst = t.idpelicula
        LEFT JOIN staging.writers_directors wd ON wd.tconst = t.idpelicula
        LEFT JOIN staging.dim_writers w ON w.idwriter = wd.writers
        LEFT JOIN staging.dim_directors d ON d.iddirector = wd.directors
        LEFT JOIN staging.dim_actors a ON a.idactor = p.nconst
);


--/---------------------------------------------------------/
--/-------------------- CHECK DATA  ------------------------/
--/---------------------------------------------------------/
SELECT * FROM staging.fact_rating WHERE idpelicula='tt0097942';

SELECT * FROM staging.dim_actors WHERE idactor='tt0098039';

select * from staging.writers_directors where tconst ='tt0097942';

select * from staging.dim_writers where idwriter = 'nm0000464';

select * from staging.dim_genres where genres1_2='Unknow,Unknow';

SELECT * FROM "title.principals" WHERE tconst='tt0098039';


-- Titulos sin generos 70658
-- Join titles and raiting total 547688
-- Join titles and raiting without nulls 245016
-- Join  wd 869809
-- Join  principals LEFT 3872899 - INNER 3856044

INSERT INTO  PRO.fact_rating
SELECT * FROM staging.fact_rating_4;

-- //-------------------------------------------------------------------//
-- //-------------  FILL DIMENSION TABLES SCHEMA PRO   -----------------//
-- //-------------------------------------------------------------------//
-- Insert all genres data in pro.dim_genres
INSERT INTO pro.dim_genres
(genres_all,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3)
SELECT
    genres_all,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3
FROM  staging.dim_genres;

-- Insert all writers data in pro.dim_writers
INSERT INTO pro.dim_writers
("primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM staging.dim_writers;

-- Insert all directors data in pro.dim_directors
INSERT INTO pro.dim_directors
("primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM
    staging.dim_directors;

-- Insert all directors data in pro.dim_titles
INSERT INTO pro.dim_titles
(primary_title, original_title, "isAdult", release_year, runtime_minutes, genres)
SELECT
    primary_title, original_title, "isAdult", release_year, runtime_minutes, genres
FROM staging.dim_titles;

-- Insert all actors data in pro.dim_titles
INSERT INTO pro.dim_actors
( "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job
FROM
    staging.dim_actors;

-- //-------------------------------------------------------------------//
-- //----------------  FILL FACT TABLES SCHEMA PRO   -------------------//
-- //-------------------------------------------------------------------//
-- Insert result values in fact table schema pro
INSERT INTO pro.fact_rating
SELECT
    title_id
     ,genres_id
     ,actor_id
     ,director_id
     ,writer_id
     ,average_rating
     ,num_votes
FROM staging.fact_rating
;
