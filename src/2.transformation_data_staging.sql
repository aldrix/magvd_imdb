-- //-------------------------------------------------------------------//
-- //--------------------       Get all Genres         ------------------//
-- //-------------------------------------------------------------------//
-- CREATE genres TEMPVIEW
CREATE OR REPLACE TEMPORARY VIEW genres AS (
                                           select DISTINCT genres AS genres
                                           from "title.basics"
                                           WHERE genres IS NOT NULL
                                               );

SELECT count(*) FROM genres;


CREATE OR REPLACE TEMPORARY VIEW genres2 AS (
                                            WITH genres2 AS (
                                                select genres
                                                     ,(CASE WHEN split_part(genres,',',1) = ''
                                                                THEN 'Unknow'
                                                            ELSE  split_part(genres,',',1)
                                                    END) AS genres1
                                                     ,(CASE WHEN split_part(genres,',',2) = ''
                                                                THEN 'Unknow'
                                                            ELSE  split_part(genres,',',2)
                                                    END) AS  genres2
                                                     ,(CASE WHEN split_part(genres,',',3) = ''
                                                                THEN 'Unknow'
                                                            ELSE  split_part(genres,',',3)
                                                    END) AS genres3
                                                FROM genres)
                                            SELECT
                                                genres
                                                 ,concat(genres1, ',', genres2) as genres1_2
                                                 ,concat(genres1, ',', genres3) as genres1_3
                                                 ,concat(genres2, ',', genres3) as genres2_3
                                                 ,genres1
                                                 ,genres2
                                                 ,genres3
                                            FROM genres2
                                            ORDER BY genres ASC);

CREATE TABLE staging.dim_genres as (select * from genres);
-- //-------------------------------------------------------------------//
-- //----------- CREATE TEMP VIEW writers_directors   ------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW writers_directors AS (
                                                      WITH writers_directors AS (
                                                          SELECT "tconst"
                                                               ,lower(unnest(string_to_array(directors, ','))) AS directors
                                                               ,lower(unnest(string_to_array(writers, ','))) AS writers
                                                          FROM "title.crew")
                                                      SELECT "tconst"
                                                           ,(CASE WHEN directors IS NOT NULL
                                                                      THEN directors
                                                                  ELSE 'unknow'
                                                          END) AS directors
                                                           ,(CASE WHEN writers IS NOT NULL
                                                                      THEN writers
                                                                  ELSE 'unknow'
                                                          END) AS writers
                                                      FROM writers_directors);

--
select * from writers_directors;

-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW directors  -----------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW directors AS(
                                             select distinct tconst, directors
                                             from writers_directors
                                             where directors != 'unknow'
                                             ORDER BY  directors ASC
                                                 );
select count(*) from directors;
--5081482

--count distinct directors without repeated values
WITH direc AS (select distinct directors
               from writers_directors
               where directors != 'unknow'
               ORDER BY  directors ASC)
select count(*) from direc;
-- 608495



-- Get directors information
CREATE OR REPLACE TEMPORARY VIEW directors2 AS (
                                               SELECT DISTINCT
                                                   directors AS idDirector
                                                             ,"primaryName"
                                                             ,"birthYear"
                                                             ,"deathYear"
                                                             ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
                                                             ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
                                                             ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
                                               from directors
                                                        LEFT join  "name.basics" on directors= nconst
                                               where directors != 'unknow'
                                               order by directors ASC
                                                   );

select count(*) from directors2;
-- 608495

CREATE TABLE staging.dim_directors as (select * from directors2);
-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW writers  -------------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW writers AS(
                                           select distinct tconst, writers
                                           from writers_directors
                                           where writers != 'unknow'
                                           ORDER BY  writers ASC
                                               );

select count(*) from writers;
--7803621

--count distinct writers without repeated values
WITH direc AS (select distinct writers
               from writers_directors
               where writers != 'unknow'
               ORDER BY  writers ASC)
select count(*) from direc;
--770209

CREATE OR REPLACE TEMPORARY VIEW writers2 AS (
                                             SELECT DISTINCT
                                                 writers as idWriter
                                                           ,"primaryName"
                                                           ,"birthYear"
                                                           ,"deathYear"
                                                           ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
                                                           ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
                                                           ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
                                             from writers
                                                      LEFT join  "name.basics" on writers= nconst
                                             where writers != 'unknow'
                                             order by writers ASC
                                                 );

select count(*) from writers2;
-- 770209

CREATE TABLE staging.dim_writers2 as (select * from writers2);
-- //-------------------------------------------------------------------//
-- //------------     CREATE TEMP VIEW TITLES         ------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW titles AS (
                                           select
                                               t.tconst as idPelicula
                                                ,"primaryTitle"
                                                ,"originalTitle"
                                                ,"isAdult"
                                                ,t."startYear" AS releaseYear
                                                ,"runtimeMinutes"
                                           from "title.basics" t
                                           WHERE T."titleType" = 'movie'
                                               );

-- count titles by
select count (tconst), "titleType"
from "title.basics" t
group by  "titleType";

select * from titles;

CREATE TABLE staging.dim_titles AS (select * from titles);

-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW ACTORS     -----------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW actors AS (
                                           select
                                               t.idPelicula
                                                ,p.nconst
                                           from titles t
                                                    LEFT JOIN "title.principals" as p on t.idPelicula = p.tconst
                                           WHERE p.category in (
                                                                'actress',
                                                                'actor')
                                               );

-- drop view actors2;
CREATE OR REPLACE TEMPORARY VIEW actors2 AS (
                                            select Distinct
                                                a.idPelicula
                                                          ,t.nconst as idActor
                                                          ,"primaryName"
                                                          ,"birthYear"
                                                          ,"deathYear"
                                                          ,(CASE WHEN split_part("primaryProfession",',',1) = ''
                                                                     THEN 'unknow'
                                                                 ELSE  split_part("primaryProfession",',',1)
                                                END) AS alternativeProfession1
                                                          ,(CASE WHEN split_part("primaryProfession",',',2) = ''
                                                                     THEN 'unknow'
                                                                 ELSE  split_part("primaryProfession",',',2)
                                                END) AS alternativeProfession2
                                                          ,(CASE WHEN split_part("primaryProfession",',',3) = ''
                                                                     THEN 'unknow'
                                                                 ELSE  split_part("primaryProfession",',',3)
                                                END) AS alternativeProfession3
                                                          ,"knownForTitles"
                                                          ,job
                                                          ,characters
                                            from "title.principals" t
                                                     INNER JOIN actors a on a.idPelicula = t.tconst
                                                     INNER JOIN  "name.basics" b on b.nconst= t.nconst
                                            ORDER BY  t.nconst ASC
                                                );

SELECT * FROM  actors2;

CREATE TABLE staging.dim_actors as (select * from actors2);
-- //-------------------------------------------------------------------//
-- //-----------------------   CROSS       -----------------------//
-- //-------------------------------------------------------------------//
CREATE TEMPORARY VIEW wd_titles AS (
                                   select
                                       wd.tconst
                                        ,wd.directors
                                        ,wd.writers
                                   from writers_directors wd
                                            LEFT JOIN titles t ON  t.idPelicula = wd.tconst


    );

with a as(
    select * from writers_directors
                      LEFT JOIN titles ON  tconst = tconst
) SELECT count(*) FROM a;


CREATE OR REPLACE TEMPORARY VIEW writers AS(select tconst,writers from wd_titles WHERE writers is not  null);
CREATE OR REPLACE TEMPORARY VIEW directors AS(select tconst,directors from wd_titles WHERE directors is not  null);

CREATE table dim_w AS (
    SELECT *
    FROM writers w);

-- drop table staging.dim_d;
CREATE table staging.dim_d AS (
    SELECT *
    FROM directors w);



INSERT INTO pro.dim_genres
(
    genres_all,
    genres1_2,
    genres1_3,
    genres2_3,
    genres1,
    genres2,
    genres3
) SELECT
      genres,
      genres1_2,
      genres1_3,
      genres2_3,
      genres1,
      genres2,
      genres3
FROM  staging.d_genres
;

-- //-------------------------------------------------------------------//
-- //-----------------------   UTILS QUERY       -----------------------//
-- //-------------------------------------------------------------------//
INSERT INTO pro.dim_genres
(genres_all,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3)
SELECT
      genres,genres1_2,genres1_3,genres2_3,genres1,genres2,genres3
FROM  staging.d_genres
;

INSERT INTO staging.dim_writers
(idwriter, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    idwriter, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM staging.d_writers;

INSERT INTO staging.dim_directors
(iddirector, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3)
SELECT
    iddirector, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3
FROM
    staging.d_directors;

INSERT INTO staging.dim_titles
(idpelicula, primary_title, original_title, "isAdult", release_year, runtime_minutes, genres)
SELECT
    idpelicula, "primaryTitle", "originalTitle", "isAdult", releaseyear, "runtimeMinutes", genres
FROM staging.d_titles;

INSERT INTO staging.dim_actors
(idactor, "primaryName", "birthYear", "deathYear", profession1, profession2, profession3, known_fo_titles, job)
SELECT
    idactor, "primaryName", "birthYear", "deathYear", alternativeprofession1, alternativeprofession2, alternativeprofession3, "knownForTitles", job
FROM
    staging.d_actors;




-- //-------------------------------------------------------------------//
-- //-----------------------   UTILS QUERY       -----------------------//
-- //-------------------------------------------------------------------//
-- Old Get genres
select
    tconst
     , lower(split_part(genres,',',1)) as genres1
     ,lower(split_part(genres,',',2)) as genres2
     ,lower(split_part(genres,',',3)) as genres3
from "title.basics";

-- Get genres without null
select tconst
     , lower(unnest(string_to_array(genres, ','))) as genres
from "title.basics";


-- writer
-- director
-- actress
-- actor