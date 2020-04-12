

-- //-------------------------------------------------------------------//
-- //--------------------       Get all Genre         ------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW genders AS (
select DISTINCT lower(unnest(string_to_array(genres, ','))) as gender
from "title.basics"
);

WITH genres AS (select DISTINCT genres AS genres
from "title.basics")
SELECT count(*)
FROM genres
WHERE genres IS NOT NULL
;

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
-- //--------------- CREATE TEMP VIEW writers  -------------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW writers AS (
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
-- //--------------- CREATE TEMP VIEW directors  -----------------------//
-- //-------------------------------------------------------------------//
-- Get directors information
CREATE OR REPLACE TEMPORARY VIEW directors AS (
SELECT
      directors AS idDirector
    ,"primaryName"
    ,"birthYear"
    ,"deathYear"
    ,lower(split_part("primaryProfession",',',1)) as alternativeProfession1
    ,lower(split_part("primaryProfession",',',2)) as alternativeProfession2
    ,lower(split_part("primaryProfession",',',3)) as alternativeProfession3
from writers_directors
    LEFT join  "name.basics" on directors= nconst
where directors != 'unknow'
order by directors ASC
);

-- //-------------------------------------------------------------------//
-- //--------------- CREATE TEMP VIEW ACTORS     -----------------------//
-- //-------------------------------------------------------------------//
CREATE OR REPLACE TEMPORARY VIEW actors AS ();



-- //-------------------------------------------------------------------//
-- //------------ Get all Writers and Directors       ------------------//
-- //-------------------------------------------------------------------//
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
FROM writers_directors;

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