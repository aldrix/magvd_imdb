-- //-------------------------------------------------------------------//
-- //------------     COUNT DATA MOVIE LENS           ------------------//
-- //-------------------------------------------------------------------//
-- Count rows in tables
SELECT count(*) FROM  ml_links;
-- 62424 links.csv
-- 62423
SELECT count(*) FROM   ml_movies;
-- 62424 movies.csv
-- 62189
SELECT count(*) FROM  ml_genome_scores;
-- 15584449 genome-scores.csv
-- 15584448
SELECT count(*) FROM  ml_genome_tags;
-- 1129 genome-tags.csv
-- 1128
SELECT count(*) FROM  ml_tags;
-- 1093361 tags.csv
-- 1090594
SELECT count(*) FROM  ml_ratings;
-- 25000096 ratings.csv
-- 25000095

-- //-------------------------------------------------------------------//
-- //------------    FORMATTING ID IMDB_MOVIELENS      -----------------//
-- //-------------------------------------------------------------------//
-- Change id format
select  substr('tt0111161', 3, length('tt0111161'));

-- Add new column to dim_titles
ALTER TABLE  pro.dim_titles ADD COLUMN  imdb_id INTEGER;

-- Update table dim_titles with imdb id
UPDATE pro.dim_titles t SET imdb_id = substr(t1.title, 3, length(t1.title))::INTEGER
from pro.dim_titles t1
where t.title_id = t1.title_id;

-- //-------------------------------------------------------------------//
-- //------------      ------------------//
-- //-------------------------------------------------------------------//
-- Create table with all information about movie_len adn datawarehouse
CREATE TABLE data_ml_mlgt AS
SELECT dw."movieId" as ml_id, dw.imdb_id, dw.title_id as dw_id , mm.title as primary_title
       ,mm.genres, mr.rating, mr."userId" as user_id, mr.timestamp as rating_time
--        ,mg.relevance as rating_relevance,  mgt."tagId" as tag_id
--        ,  mgt.tag as tag_name
--        ,mt.timestamp as tag_time ,mt.tag as tag_user_mv
FROM ml_movies mm
left join ml_dw_imdb dw on imdb_id = mm."movieId"
left join ml_ratings mr on dw."movieId" = mr."movieId"
-- left join ml_genome_scores mg on mg."movieId" = mm."movieId"
-- left join ml_genome_tags mgt on mg."tagId" = mgt."tagId"
-- left join ml_tags mt on dw."movieId" = mt."movieId" and mt."userId" = mr."userId"+
;

-- //-------------------------------------------------------------------//
-- //------------   CHECK MOVIES IN DIM_TITLES DW     ------------------//
-- //-------------------------------------------------------------------//
-- Looking information about the movies in data warehouse
CREATE TABLE ml_dw_imdb AS
with get_imdb_id as (
    select m."movieId", l."imdbId"  as imdb_id
    from ml_movies m
             left join ml_links l on m."movieId" = l."movieId"
) select i."movieId", i.imdb_id, t.title_id
from get_imdb_id i
         left join pro.dim_titles t on t.imdb_id = i.imdb_id;
-- count(*) 62189 ml_dw_imdb


-- Insert new titles from movie_len in datawarehouse
-- INSERT INTO pro.dim_titles as
CREATE TABLE titles as
with aux as (
    select  "movieId" as ml_id, imdb_id, title_id, title_id::integer as release_year, title_id as primary_title
    from ml_dw_imdb
    where title_id is null
    )SELECT * FROM aux a
                       left join ml_movies m on a.ml_id = m."movieId"
--                        left join pro.dim_titles t on  t.primary_title = m.title or t.original_title = m.title
;
-- Numero de peliculas que no estan en el datawarehouse son 9375

-- Update release year in titles
UPDATE  titles t1 set release_year = SUBSTRING( t2.title, '([0-9]{4})' )::integer
FROM titles t2
where t1.ml_id =t2.ml_id;

select min(release_year), max(release_year)
from titles
;

-- Get release date from title string and right values will be date > 1873 and date < 2020
select *
from titles
where release_year < 1873 and release_year>2020;

-- Insert primary_title in titles
UPDATE  titles t1 set primary_title =  split_part(t2.title,' (',1)
FROM titles t2
where t1.ml_id =t2.ml_id;

-- Insert news titles in dw dim_titles
INSERT INTO PRO.dim_titles( primary_title, original_title, release_year, imdb_id)
select t.primary_title, t.primary_title as original_title, release_year, imdb_id
from titles t
;

-- //-------------------------------------------------------------------//
-- //------------      CREATE TEMP VIEWS GENRES       ------------------//
-- //-------------------------------------------------------------------//
-- Validate genres
-- drop view ml_genres;
-- Create view with all ml genres
CREATE OR REPLACE TEMPORARY VIEW ml_genres AS (
                                              WITH genres2 AS (
                                                  select
                                                      genres
                                                       ,(CASE WHEN split_part(genres,',',1) = ''
                                                                  THEN ''
                                                              ELSE  split_part(genres,',',1)
                                                      END) AS genres1
                                                       ,(CASE WHEN split_part(genres,',',2) = ''
                                                                  THEN ''
                                                              ELSE  split_part(genres,',',2)
                                                      END) AS  genres2
                                                       ,(CASE WHEN split_part(genres,',',3) = ''
                                                                  THEN ''
                                                              ELSE  split_part(genres,',',3)
                                                      END) AS genres3
                                                  FROM (select REPLACE (genres, '|', ',')   as genres
                                                        from (select DISTINCT  genres from ml_movies) as f) as ml_genres)
                                              SELECT Distinct
                                                  genres
                                                            ,(CASE WHEN genres3 = '' and genres2 = ''
                                                                       THEN genres1
                                                                   when genres3 = ''
                                                                       THEN concat(genres1,',', genres2)
                                                                   when genres2 = ''
                                                                       THEN genres1
                                                                   ELSE  concat(genres1,',', genres2, ',', genres3)
                                                  END) AS genres_dw
                                                            ,concat(genres1, ',', genres2) as genres1_2
                                                            ,concat(genres1, ',', genres3) as genres1_3
                                                            ,concat(genres2, ',', genres3) as genres2_3
                                                            ,genres1
                                                            ,genres2
                                                            ,genres3
                                              FROM genres2
                                              ORDER BY genres ASC);

-- table to connect genres dw and ml
CREATE TABLE  genres_ml_dw as
select ml_genres.genres as genres_ml, genres_dw  from ml_genres;

select * from genres_ml_dw;

select count(*) from (select distinct genres_dw from ml_genres) f;

-- drop table ml_genres;
CREATE TABLE genres as
select distinct  genres_dw, genres1_2, genres1_3, genres2_3, genres1, genres2, genres3 from ml_genres;

-- drop view genres2 ;
CREATE OR REPLACE TEMPORARY VIEW genres2 AS (
                                            WITH genres2 AS (
                                                select genres_dw as genres
                                                     ,(CASE WHEN split_part(genres_dw,',',1) = ''
                                                                THEN 'Unknown'
                                                            ELSE  split_part(genres_dw,',',1)
                                                    END) AS genres1
                                                     ,(CASE WHEN split_part(genres_dw,',',2) = ''
                                                                THEN 'Unknown'
                                                            ELSE  split_part(genres_dw,',',2)
                                                    END) AS  genres2
                                                     ,(CASE WHEN split_part(genres_dw,',',3) = ''
                                                                THEN 'Unknown'
                                                            ELSE  split_part(genres_dw,',',3)
                                                    END) AS genres3
                                                FROM ml_genres)
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

-- Insert mew 121 genres in dw
-- A partir del 2246 se inserto
insert into pro.dim_genres (genres,  genres1_2, genres1_3, genres2_3, genres1, genres2, genres3)
select distinct  g.genres,  g.genres1_2, g.genres1_3, g.genres2_3, g.genres1, g.genres2, g.genres3
from genres2 g
         left join  pro.dim_genres d on d.genres = g.genres
where d.genres_id is null and g.genres != '(no genres listed)'
;

-- //-------------------------------------------------------------------//
-- //------------      CREATE USER DIM    ??   ------------------//
-- //-------------------------------------------------------------------//
-- Necesito crear una dim_user?
SELECT  *
from ml_ratings r
left join ml_tags mt on r."userId" = mt."userId";