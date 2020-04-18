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

-- Change id format
select  substr('tt0111161', 3, length('tt0111161'));

-- Add new column to dim_titles
ALTER TABLE  pro.dim_titles ADD COLUMN  imdb_id INTEGER;

-- Update table dim_titles with imdb id
UPDATE pro.dim_titles t SET imdb_id = substr(t1.title, 3, length(t1.title))::INTEGER
from pro.dim_titles t1
where t.title_id = t1.title_id;

-- Get values
select title_id, title, imdb_id from pro.dim_titles;



-- Looking information about the movies in data warehouse
CREATE TABLE ml_dw_imdb AS
with get_imdb_id as (
    select m."movieId", l."imdbId"  as imdb_id
    from ml_movies m
             left join ml_links l on m."movieId" = l."movieId"
) select i."movieId", i.imdb_id, t.title_id
from get_imdb_id i
left join pro.dim_titles t on t.imdb_id = i.imdb_id;
-- count(*) 62189


SELECT count(*) FROM ml_dw_imdb;



create temp view  len_imdb as
;

with aux as (
    select t.title_id,
           t.title,
           li.title,
           li.imdb,
           tmdbid,
           movieid,
           li.title,
           genres
    from pro.dim_titles t
             left join len_imdb li on t.title = li.imdb
) select count(*)
from aux
;

select *
from len_imdb


select 00562;