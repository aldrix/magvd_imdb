-- DROP TABLE staging.fact_rating;






-- Creating table
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

-- Check data
SELECT * FROM staging.fact_rating WHERE idpelicula='tt0097942';

SELECT * FROM staging.dim_actors WHERE idactor='tt0098039';

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


CREATE  TABLE staging.fact_rating1 AS (
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

CREATE  TABLE staging.fact_rating2 AS (
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

CREATE  TABLE staging.fact_rating3 AS (
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

ALTER TABLE staging.dim_directors set schema pro;

update  staging.fact_rating set average_rating = 0, num_votes=0
where average_rating is null


-- WITH  fr
INSERT INTO pro.fact_rating
SELECT
    title_id
     ,genres_id
     ,actor_id
     ,director_id
     ,writer_id
     ,average_rating
     ,num_votes
FROM staging.fact_rating3
WHERE actor_id is not null or
    writer_id IS NOT NULL OR
    director_id IS NOT NULL
;

