

-- //-------------------------------------------------------------------//
-- //--------------------       Get all Genre         ------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW genders AS (
select DISTINCT lower(unnest(string_to_array(genres, ','))) as gender
from "title.basics"
);

WITH g AS (select  genres AS genres
     ,count(tconst)
from "title.basics"
WHERE  genres is not null
group by genres)
SELECT count(*)
FROM g;

WITH genres AS (select DISTINCT genres AS genres
from "title.basics")
SELECT count(*)
FROM genres
WHERE genres IS NOT NULL;

-- Creamos primera temview de genres
CREATE OR REPLACE TEMPORARY VIEW genders AS (
    select DISTINCT genres AS genres
    from "title.basics"
    WHERE genres IS NOT NULL
);

-- set unknow in genres
WITH genres2 AS (
    select genres
         ,(CASE WHEN split_part(genres,',',1) = ''
                    THEN 'Unknow'
                ELSE  split_part(genres,',',1)
        END) AS gender1
         ,(CASE WHEN split_part(genres,',',2) = ''
                    THEN 'Unknow'
                ELSE  split_part(genres,',',2)
        END) AS  gender2
         ,(CASE WHEN split_part(genres,',',3) = ''
                        THEN 'Unknow'
                ELSE  split_part(genres,',',3)
        END) AS gender3
    FROM genders)
SELECT
    genres
    ,concat(gender1, ',', gender2) as genres1_2
    ,concat(gender1, ',', gender3) as genres1_3
    ,concat(gender2, ',', gender3) as genres2_3
    ,gender1
    ,gender2
    ,gender3
FROM genres2
ORDER BY genres ASC ;

-- dim_genre
CREATE OR REPLACE TEMPORARY VIEW dim_genders AS (
                                                WITH genres2 AS (
                                                    select genres
                                                         ,(CASE WHEN split_part(genres,',',1) = ''
                                                                    THEN 'Unknow'
                                                                ELSE  split_part(genres,',',1)
                                                        END) AS gender1
                                                         ,(CASE WHEN split_part(genres,',',2) = ''
                                                                    THEN 'Unknow'
                                                                ELSE  split_part(genres,',',2)
                                                        END) AS  gender2
                                                         ,(CASE WHEN split_part(genres,',',3) = ''
                                                                    THEN 'Unknow'
                                                                ELSE  split_part(genres,',',3)
                                                        END) AS gender3
                                                    FROM genders)
                                                SELECT
                                                    genres
                                                     ,concat(gender1, ',', gender2) as genres1_2
                                                     ,concat(gender1, ',', gender3) as genres1_3
                                                     ,concat(gender2, ',', gender3) as genres2_3
                                                     ,gender1
                                                     ,gender2
                                                     ,gender3
                                                FROM genres2
                                                ORDER BY genres ASC);

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
order by directors ASC;

CREATE OR REPLACE TEMPORARY VIEW directors AS (

                                              );
-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW writers  -------------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW directors AS(
                                             select distinct tconst, directors
                                             from writers_directors
                                             where directors != 'unknow'
                                             ORDER BY  directors ASC
);

CREATE OR REPLACE TEMPORARY VIEW writers AS (
    SELECT DISTINCT
        writers as idWriter
         ,"primaryName"
         ,"birthYear"
         ,"deathYear"
         ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
         ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
         ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
    from
             LEFT join  "name.basics" on writers= nconst
    where writers != 'unknow'
    order by writers ASC
);

SELECT DISTINCT
    writers as idWriter
     ,"primaryName"
     ,"birthYear"
     ,"deathYear"
     ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
     ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
     ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
from writers_directors
         LEFT join  "name.basics" on writers= nconst
where writers != 'unknow'
order by writers ASC;



-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW ACTORS     -----------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW actors AS ();


select
    t.nconst as idActor
    ,"primaryName"
    ,"birthYear"
    ,"deathYear"
    ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
    ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
    ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
    ,"knownForTitles"
    ,job
    ,characters
from "title.principals" t
         LEFT join  "name.basics" b on b.nconst= t.nconst
;

-- //-------------------------------------------------------------------//
-- //------------     CREATE TEMP VIEW TITLES         ------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW TITLES AS ();

select
    t.tconst as idPelicula
     ,"primaryTitle"
     ,"originalTitle"
     ,"isAdult"
     ,t."startYear" AS releaseYear
     ,"runtimeMinutes"
from "title.basics" t
WHERE T."titleType" = 'movie'
;

-- count titles by
select count (tconst), "titleType"
from "title.basics" t
group by  "titleType";


-- //-------------------------------------------------------------------//
-- //-----------------------   UTILS QUERY       -----------------------//
-- //-------------------------------------------------------------------//
-- Old Get gender
select
    tconst
     , lower(split_part(genres,',',1)) as gender1
     ,lower(split_part(genres,',',2)) as gender2
     ,lower(split_part(genres,',',3)) as gender3
from "title.basics";

-- Get gender without null
select tconst
     , lower(unnest(string_to_array(genres, ','))) as gender
from "title.basics";