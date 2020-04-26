-- //-------------------------------------------------------------------//
-- //-------------  FILL DIMENSION TABLES SCHEMA PRO   -----------------//
-- //-------------------------------------------------------------------//
-- //------------- GENRES
SELECT count(*) FROM  staging.dim_genres;
-- 2246

-- Insert all genres data in pro.dim_genres
INSERT INTO pro.dim_genres(genres,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3)
SELECT DISTINCT genres,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3 FROM  staging.dim_genres;

SELECT count(*) FROM  pro.dim_genres;
-- 2246

-- //-------------------------------------------------------------------//
-- //------------- TITLES
WITH AUX AS (SELECT DISTINCT idpelicula, primary_title, original_title, "isAdult", release_year, runtime_minutes, genres
             FROM  staging.dim_titles)
SELECT count(*) FROM AUX;
-- 547688

-- Insert all directors data in pro.dim_titles
INSERT INTO pro.dim_titles
(title, primary_title, original_title, "is_adult", release_year, runtime_minutes)
SELECT
    DISTINCT idpelicula,primary_title, original_title, "isAdult", release_year, runtime_minutes
FROM staging.dim_titles;

SELECT count(*) FROM  pro.dim_titles;
--547688

-- //-------------------------------------------------------------------//
-- //------------- ACTORS
WITH AUX AS (SELECT DISTINCT actor, primary_name, birth_year, death_year, profession1, profession2, profession3, know_for_titles
             FROM  staging.dim_actors)
SELECT count(*) FROM AUX;
-- 589846

-- Insert all actors data in pro.dim_titles
INSERT INTO pro.dim_actors
(actor, primary_name, birth_year, death_year, profession1, profession2, profession3, known_for_titles)
SELECT
    DISTINCT  actor, primary_name, birth_year, death_year, profession1, profession2, profession3, know_for_titles
FROM
    staging.dim_actors;

SELECT count(*) FROM  pro.dim_actors;
-- 589846

-- //-------------------------------------------------------------------//
-- //------------- WRITER
WITH AUX AS (SELECT  DISTINCT writer, primary_name, birth_year, death_year, profession1, profession2, profession3
             FROM  staging.dim_writers)
SELECT count(*) FROM AUX;
-- 283519

-- Insert all writers data in pro.dim_writers
INSERT INTO pro.dim_writers
( writer, primary_name, birth_year, death_year, profession1, profession2, profession3)
SELECT DISTINCT writer, primary_name, birth_year, death_year, profession1, profession2, profession3
FROM staging.dim_writers;


SELECT  count(*) FROM  pro.dim_writers;
-- 283519

SELECT
    writer, primary_name, birth_year, death_year, profession1, profession2, profession3,  count(*)
FROM staging.dim_writers
GROUP BY   writer, primary_name, birth_year, death_year, profession1, profession2, profession3
HAVING count(*) > 1;

-- //-------------------------------------------------------------------//
-- //------------- DIRECTOR
WITH AUX AS (SELECT  DISTINCT director, primary_name, birth_year, death_year, profession1, profession2, profession3
             FROM  staging.dim_directors)
SELECT count(*) FROM AUX;
-- 205018

-- Insert all directors data in pro.dim_directors
INSERT INTO pro.dim_directors (director, primary_name, birth_year, death_year, profession1, profession2, profession3)
SELECT DISTINCT director, primary_name, birth_year, death_year, profession1, profession2, profession3
FROM staging.dim_directors;

SELECT count(*) FROM  pro.dim_directors;
--205018


--/---------------------------------------------------------/
--/------------- CREATE TABLES FACT TABLE  -----------------/
--/---------------------------------------------------------/
-- DROP TABLE staging.fact_rating;

-- First approach to fill fact table in staging
-- CREATE TABLE staging.fact_rating AS (
CREATE TEMP VIEW  profact as (
    SELECT DISTINCT
        t.title_id
        ,t.idpelicula
        ,t.original_title
        ,g.genres
        ,a.actor
        ,d.director
        ,w.writer
        ,CASE  WHEN r.averagerating IS NULL
               THEN 0
           ELSE r.averagerating
        END  AS average_rating
        ,CASE  WHEN r.numvotes IS NULL
               THEN 0
           ELSE r.numvotes
        END  AS num_votes
        FROM staging.dim_titles t
        LEFT JOIN "title.ratings" r ON t.idpelicula = r.tconst
        LEFT JOIN staging.dim_genres g ON g.genres = t.genres
        LEFT JOIN "title.principals" p ON p.tconst = t.idpelicula
        LEFT JOIN staging.writers w1 ON w1.tconst = t.idpelicula
        LEFT JOIN staging.directors d1 ON d1.tconst = t.idpelicula
        LEFT JOIN staging.dim_writers w ON w.writer = w1.writers
        LEFT JOIN staging.dim_directors d ON d.director = d1.directors
        LEFT JOIN staging.dim_actors a ON a.actor = p.nconst
);


CREATE TABLE staging.fact1 as (
    SELECT DISTINCT
        t.title_id
                  ,t.original_title
                  ,t.idpelicula
                  ,(CASE WHEN g.genres IS NULL
                             THEN 'Unknown'
                         ELSE  g.genres
        END) AS genres
                  ,(CASE WHEN  a.actor IS NULL
                             THEN 'nm0000000'
                         ELSE  a.actor
        END) AS  actor
                  ,(CASE WHEN d.director IS NULL
                             THEN 'nm0000000'
                         ELSE  d.director
        END) AS director
                  ,(CASE WHEN w.writer IS NULL
                             THEN 'nm0000000'
                         ELSE  w.writer
        END) AS writer
                  ,CASE  WHEN r.averagerating IS NULL
                             THEN 0
                         ELSE r.averagerating
        END  AS average_rating
                  ,CASE  WHEN r.numvotes IS NULL
                             THEN 0
                         ELSE r.numvotes
        END  AS num_votes
    FROM staging.dim_titles t
             LEFT JOIN "title.ratings" r ON t.idpelicula = r.tconst
             LEFT JOIN staging.dim_genres g ON g.genres = t.genres
             LEFT JOIN staging.d_actors a1 ON a1.idpelicula = t.idpelicula
             LEFT JOIN staging.writers w1 ON w1.tconst = t.idpelicula
             LEFT JOIN staging.directors d1 ON d1.tconst = t.idpelicula
             LEFT JOIN staging.dim_writers w ON w.writer = w1.writers
             LEFT JOIN staging.dim_directors d ON d.director = d1.directors
             LEFT JOIN staging.dim_actors a ON a.actor = a1.idactor);




-- nm0000000,Unknown
-- nm0000000
--/---------------------------------------------------------/
--/-------------------- CHECK DATA  ------------------------/
--/---------------------------------------------------------/

select title_id, t.idpelicula, genres, writer
FROM staging.dim_titles t
LEFT JOIN staging.writers w1 ON w1.tconst = t.idpelicula
LEFT JOIN staging.dim_writers w ON w.writer = w1.writers
;

SELECT * FROM pro.dim_directors where primary_name =  'Unknown';
SELECT * FROM pro.dim_genres where genres = 'Unknown,Unknown,Unknown';

WHERE idpelicula='tt0097942';

SELECT * FROM staging.dim_titles WHERE idpelicula ='tt0097940';

select * from staging.d_titles where title='tt0000502';

select * from staging.dim_writers where idwriter = 'nm0000464';

select * from pro.dim_genres where genres='Unknown,Unknown,Unknown';

SELECT * FROM "title.principals" WHERE tconst='tt0098039';


-- Titulos sin generos 70658
-- Join titles and raiting total 547688
-- Join titles and raiting without nulls 245016
-- Join  wd 869809
-- Join  principals LEFT 3872899 - INNER 3856044



-- //-------------------------------------------------------------------//
-- //----------------  FILL FACT TABLES SCHEMA PRO   -------------------//
-- //-------------------------------------------------------------------//
CREATE TABLE  staging.fact AS (
    SELECT DISTINCT
        title_id
      ,genres_id
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
    FROM pro.dim_titles t
             LEFT JOIN "title.ratings" r ON t.title = r.tconst
             LEFT JOIN pro.dim_genres g ON g.genres = t.genres
             LEFT JOIN "title.principals" p ON p.tconst = t.title
             LEFT JOIN staging.old_writers_directors wd ON wd.tconst = t.title
             LEFT JOIN pro.dim_writers w ON w.writer = wd.writers
             LEFT JOIN pro.dim_directors d ON d.director = wd.directors
             LEFT JOIN pro.dim_actors a ON a.actor = p.nconst
);


-- 6542411 all
DELETE FROM staging.fact
where actor_id is null;

-- 3251970
select  COUNT(*) FROM staging.fact_rating;


select  * FROM staging.fact WHERE title_id =2;
limit 5;
-- VALORES NULL
-- title_id 0
-- genres_id 0
-- a.actor_id  147065
-- d.director_id 2531323
-- w.writer_id 5771193

select  title_id, count(*) FROM staging.fact
where actor_id = 694 and title_id= 12577
group by title_id;


select * from pro.dim_titles where title_id= 12577;

select * from garbage.actors where idpelicula= 'tt0020163';
select * from "title.principals" p where p.tconst= 'tt0020163';

select * from pro.dim_actors where actor in ('nm0000697');



select  count(*) FROM garbage.actors where nconst is not null;
-- 1716530


select * from pro.dim_actors where actor in (
'nm0000697'
,'nm0819265'
,'nm0096030'
,'nm0903188'
,'nm0251203'
,'nm0802563'
,'nm0880618'
,'nm0322843'
,'nm0802561'
,'nm0003593');



-- Insert result values in fact table schema pro
INSERT INTO pro.fact_rating
SELECT
    t.title_id
     ,genres_id
     ,actor_id
     ,director_id
     ,writer_id
     ,average_rating
     ,num_votes
FROM staging.fact1 f
join pro.dim_titles t on t.title = f.idpelicula
join pro.dim_genres g on f.genres = g.genres
join pro.dim_directors  d on d.director = f.director
join pro.dim_actors a on a.actor = f.actor
join pro.dim_writers w on w.writer = f.writer

;

SELECT
    primary_name, birth_year, death_year, profession1, profession2, profession3,  count(*)
FROM pro.dim_directors
GROUP BY  primary_name, birth_year, death_year, profession1, profession2, profession3
HAVING count(*) > 1;
