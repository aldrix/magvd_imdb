INSERT INTO pro.dim_writers
(idwriter, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    idwriter, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM staging.d_writers;

INSERT INTO pro.dim_directors
(iddirector, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    iddirector, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM
staging.d_directors;

INSERT INTO pro.dim_titles
(idpelicula, primary_title, original_title, "isAdult", release_year, runtime_minutes, genres)
SELECT
    idpelicula, "primaryTitle", "originalTitle", "isAdult", releaseyear, "runtimeMinutes", genres
FROM staging.d_titles;

INSERT INTO pro.dim_actors
(idactor, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job)
SELECT
    idactor, "primaryName", "birthYear", "deathYear", alternativeprofession1, alternativeprofession2, alternativeprofession3, "knownForTitles", job
FROM
    staging.d_actors;


CREATE TABLE staging.dim_actors AS SELECT * FROM PRO.dim_actors;
CREATE TABLE staging.dim_titles AS SELECT * FROM PRO.dim_titles;
CREATE TABLE staging.dim_writers AS SELECT * FROM PRO.dim_writers;
CREATE TABLE staging.dim_directors AS SELECT * FROM PRO.dim_directors;
CREATE TABLE staging.dim_genres AS SELECT * FROM PRO.dim_genres;

-- DROP TABLE staging.fact_rating;

-- Creating table
CREATE TABLE staging.fact_rating_1 AS (
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


CREATE  TABLE staging.fact_rating_2 AS (
    SELECT
        title_id
         ,genres_id
         ,actor_id
         ,director_id
         ,writer_id
         ,average_rating
         ,num_votes
    FROM staging.fact_rating
    WHERE actor_id is not null
);

CREATE  TABLE staging.fact_rating_3 AS (
    SELECT
        title_id
         ,genres_id
         ,actor_id
         ,director_id
         ,writer_id
         ,average_rating
         ,num_votes
    FROM staging.fact_rating1
    WHERE  writer_id IS NOT NULL
);

CREATE  TABLE staging.fact_rating_4 AS (
    SELECT
        title_id
         ,genres_id
         ,actor_id
         ,director_id
         ,writer_id
         ,average_rating
         ,num_votes
    FROM staging.fact_rating2
    WHERE director_id IS NOT NULL
);


INSERT INTO  PRO.fact_rating
SELECT * FROM staging.fact_rating_4;

-- Check data
SELECT * FROM staging.fact_rating WHERE idpelicula='tt0097942';

SELECT * FROM staging.dim_actors WHERE idactor='tt0098039';
SELECT * FROM pro.dim_genres WHERE genres_all = 'Unknow,Unknow,Unknow'; --2246
SELECT * FROM staging.dim_genres WHERE genres_all = 'Unknow,Unknow,Unknow';

SELECT * FROM "title.principals" WHERE tconst='tt0098039';


-- Titulos sin generos 70658
-- Join titles and raiting total 547688
-- Join titles and raiting without nulls 245016
-- Join  wd 869809
-- Join  principals LEFT 3872899 - INNER 3856044

select * from staging.writers_directors where tconst ='tt0097942';

select * from staging.dim_writers where idwriter = 'nm0000464';

select * from staging.dim_genres where genres1_2='Unknow,Unknow';


-- 12 338 928
SELECT title_id,  count(actor_id), count(genres_id), count(director_id), count(writer_id)
FROM staging.fact_rating
where title_id = 3
group by title_id;

SELECT actor_id, count(actor_id), director_id, count(genres_id)
FROM staging.fact_rating
where title_id = 3
group by director_id, actor_id;


SELECT * FROM staging.fact_rating3;


ALTER TABLE staging.dim_directors set schema pro;


-- //-------------------------------------------------------------------//
-- //-------------------------  FILL PRO      --------------------------//
-- //-------------------------------------------------------------------//
INSERT INTO pro.dim_genres
(genres_all,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3)
SELECT
    genres_all,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3
FROM  staging.dim_genres
;

INSERT INTO pro.dim_writers
("primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM staging.dim_writers;

INSERT INTO pro.dim_directors
("primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM
    staging.dim_directors;

INSERT INTO pro.dim_titles
(primary_title, original_title, "isAdult", release_year, runtime_minutes, genres)
SELECT
    primary_title, original_title, "isAdult", release_year, runtime_minutes, genres
FROM staging.dim_titles;

INSERT INTO pro.dim_actors
( "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job)
SELECT
    "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job
FROM
    staging.dim_actors;


-- Insert values in fact table schema pro
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

