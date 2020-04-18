-- //-------------------------------------------------------------------//
-- //-----------------   CREATE TEMP VIEWS GENRES     ------------------//
-- //-------------------------------------------------------------------//
-- Get all genres not null from basics
CREATE OR REPLACE TEMPORARY VIEW genres AS (
                                           select DISTINCT genres AS genres
                                           from "title.basics"
                                           WHERE genres IS NOT NULL
                                               );

SELECT count(*) FROM genres;

-- split string genres by ´,´ in three and replace null genres by Unknown
CREATE OR REPLACE TEMPORARY VIEW genres2 AS (
                                            WITH genres2 AS (
                                                select genres
                                                     ,(CASE WHEN split_part(genres,',',1) = ''
                                                                THEN 'Unknown'
                                                            ELSE  split_part(genres,',',1)
                                                    END) AS genres1
                                                     ,(CASE WHEN split_part(genres,',',2) = ''
                                                                THEN 'Unknown'
                                                            ELSE  split_part(genres,',',2)
                                                    END) AS  genres2
                                                     ,(CASE WHEN split_part(genres,',',3) = ''
                                                                THEN 'Unknown'
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

-- First staging table
CREATE TABLE staging.d_genres as (select * from genres2);

-- GENRES
-- Count genres rows
select count (*) from staging.d_genres;
-- 2246

-- Check table to validate duplicate information
SELECT
    g.genres,  count(*)
FROM staging.d_genres g
GROUP BY g.genres
HAVING count(*) > 1;

-- DIM
CREATE TABLE  staging.dim_genres as (
    select *
    from  staging.d_genres);

-- //-------------------------------------------------------------------//
-- //------------     CREATE TEMP VIEW TITLES         ------------------//
-- //-------------------------------------------------------------------//
-- Get all movie title  from  title.basics
CREATE OR REPLACE TEMPORARY VIEW titles AS (
                                           select
                                               t.tconst as titles
                                                ,"primaryTitle"
                                                ,"originalTitle"
                                                ,"isAdult"
                                                ,t."startYear" AS releaseYear
                                                ,"runtimeMinutes"
                                           from "title.basics" t
                                           WHERE T."titleType" = 'movie'
                                               );
select * from titles;

-- count titles by
select count (tconst), "titleType"
from "title.basics" t
group by  "titleType";


-- First staging table
CREATE TABLE staging.d_titles AS (select * from titles);

-- count titles by
select count (tconst), "titleType"
from "title.basics" t
group by  "titleType";

-- First staging table
CREATE TABLE staging.d_titles AS (
    SELECT
        d_titles.title
        ,"primaryTitle" AS primary_title
        ,"originalTitle"  AS original_title
        ,"isAdult" AS is_adult
        ,releaseyear AS release_year
        ,"runtimeMinutes" AS runtime_minutes
        ,genres
FROM staging.d_titles);


-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW ACTORS     -----------------------//
-- //-------------------------------------------------------------------//
-- Get all movie actors
CREATE OR REPLACE TEMPORARY VIEW actors AS (
                                           select DISTINCT
                                               t.title
                                                         ,p.nconst
                                           from titles t
                                                    LEFT JOIN "title.principals" as p on t.title = p.tconst
                                           WHERE p.category in (
                                                                'actress',
                                                                'actor')
                                               );

-- Get information about the actors title.principals and select three principals profession
CREATE OR REPLACE TEMPORARY VIEW actors2 AS (
                                            select Distinct
                                                a.title as title
                                                          ,b.nconst as idActor
                                                          ,b."primaryName" as "primary_name"
                                                          ,b."birthYear" as  "birth_year"
                                                          ,b."deathYear" as "death_year"
                                                          ,(CASE WHEN split_part("primaryProfession",',',1) = ''
                                                                     THEN 'Unknown'
                                                                 ELSE  split_part("primaryProfession",',',1)
                                                END) AS profession1
                                                          ,(CASE WHEN split_part("primaryProfession",',',2) = ''
                                                                     THEN 'Unknown'
                                                                 ELSE  split_part("primaryProfession",',',2)
                                                END) AS profession2
                                                          ,(CASE WHEN split_part("primaryProfession",',',3) = ''
                                                                     THEN 'Unknown'
                                                                 ELSE  split_part("primaryProfession",',',3)
                                                END) AS profession3
                                                          ,"knownForTitles"
                                            from actors a
                                                     LEFT JOIN  "name.basics" b on a.nconst = b.nconst
                                            ORDER BY  a.title ASC
                                                );


-- First staging table
CREATE TABLE staging.d_actors as (select * from actors2);

SELECT COUNT(idactor) FROM staging.d_actors;
-- all 1716196  idactor 1713357


-- TODO CHARLES
--Vista de tabla de actores
CREATE TABLE staging.dim_actors as
select distinct idactor as actor, "primaryName" as primary_name, "birthYear" as birth_year, "deathYear" as death_year,
                alternativeprofession1 as profession1, alternativeprofession2 as profession2, alternativeprofession3 as profession3,
                "knownForTitles" as know_for_titles
from staging.d_actors da;

-- //-------------------------------------------------------------------//
-- //------------ CREATE TEMP VIEWS DIRECTOR WRITERS   -----------------//
-- //-------------------------------------------------------------------//
-- Get all know diretors from  writers_directors
select count(*) from staging.writers;
--699346

-- Get all movie writter and directors from crew
CREATE OR REPLACE TEMPORARY VIEW writers_directors AS (
                                                      WITH writers_directors AS (
                                                          SELECT "tconst"
                                                               ,lower(unnest(string_to_array(directors, ','))) AS directors
                                                               ,lower(unnest(string_to_array(writers, ','))) AS writers
                                                          FROM "title.crew")
                                                      SELECT  DISTINCT  "tconst"
                                                                     ,(CASE WHEN directors IS NOT NULL
                                                                                THEN directors
                                                                            ELSE 'Unknown'
                                                          END) AS directors
                                                                     ,(CASE WHEN writers IS NOT NULL
                                                                                THEN writers
                                                                            ELSE 'Unknown'
                                                          END) AS writers
                                                      FROM staging.d_titles
                                                      LEFT JOIN  writers_directors ON title = tconst );

select * from writers_directors limit 10;

CREATE TABLE staging.writers_directors as (select * from writers_directors);

CREATE TABLE staging.writers as (
    select DISTINCT tconst, writers from writers_directors where writers != 'Unknown');


CREATE TABLE staging.directors as (
    select DISTINCT tconst, directors from writers_directors where directors != 'Unknown');


-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW DIRECTORS  -----------------------//
-- //-------------------------------------------------------------------//
-- Get all know diretors from  writers_directors
select count(*) from staging.directors;
--548079

-- Get information about the directors and select three principals profession
CREATE TABLE staging.d_directors AS (

                                               SELECT DISTINCT
                                                   directors.directors as director
                                                             ,b."primaryName" as "primary_name"
                                                             ,b."birthYear" as  "birth_year"
                                                             ,b."deathYear" as "death_year"
                                                             ,(CASE WHEN split_part("primaryProfession",',',1) = ''
                                                                        THEN 'Unknown'
                                                                    ELSE  split_part("primaryProfession",',',1)
                                                   END) AS profession1
                                                             ,(CASE WHEN split_part("primaryProfession",',',2) = ''
                                                                        THEN 'Unknown'
                                                                    ELSE  split_part("primaryProfession",',',2)
                                                   END) AS profession2
                                                             ,(CASE WHEN split_part("primaryProfession",',',3) = ''
                                                                        THEN 'Unknown'
                                                                    ELSE  split_part("primaryProfession",',',3)
                                                   END) AS profession3
                                               from staging.directors
                                                        LEFT join  "name.basics" b on directors = nconst
                                               where b."primaryName" is not null and b."primaryName" != ''
                                               order by directors.directors ASC
                                                   );

select count(*) from staging.d_directors;
-- 205018

CREATE TABLE staging.dim_directors as (select * from staging.d_directors);

-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW WRITERS  -------------------------//
-- //-------------------------------------------------------------------//
select count(*) from staging.writers;
--699346

-- Get information about the writters and select three principals profession
CREATE TABLE staging.d_writers  AS (
                                             SELECT DISTINCT
                                                 writers as writer
                                                           ,b."primaryName" as "primary_name"
                                                           ,b."birthYear" as  "birth_year"
                                                           ,b."deathYear" as "death_year"
                                                           ,(CASE WHEN split_part("primaryProfession",',',1) = ''
                                                                      THEN 'Unknown'
                                                                  ELSE  split_part("primaryProfession",',',1)
                                                 END) AS profession1
                                                           ,(CASE WHEN split_part("primaryProfession",',',2) = ''
                                                                      THEN 'Unknown'
                                                                  ELSE  split_part("primaryProfession",',',2)
                                                 END) AS profession2
                                                           ,(CASE WHEN split_part("primaryProfession",',',3) = ''
                                                                      THEN 'Unknown'
                                                                  ELSE  split_part("primaryProfession",',',3)
                                                 END) AS profession3
                                             from staging.writers
                                                      LEFT join  "name.basics" b on writers= nconst
                                             where b."primaryName" is not null and b."primaryName" !=''
                                             order by writers ASC
                                                 );

select * from staging.d_writers limit 10;

select count(*) from staging.d_writers;
-- 283519

CREATE TABLE staging.dim_writers as (select * from staging.d_writers);



