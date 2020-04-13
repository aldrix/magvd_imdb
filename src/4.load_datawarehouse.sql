
WITH temp_count AS (
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
                         ELSE genres_id
        END  AS average_rating
                  ,CASE  WHEN r.numvotes IS NULL
                             THEN 0
                         ELSE genres_id
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
)SELECT count(*)
FROM temp_count
;


-- Creating table
DROP TABLE staging.fact_rating;

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
           ELSE genres_id
        END  AS average_rating
        ,CASE  WHEN r.numvotes IS NULL
               THEN 0
           ELSE genres_id
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
SELECT * FROM staging.fact_rating WHERE idpelicula='tt0098039';

SELECT * FROM staging.dim_actors WHERE idactor='tt0098039';

SELECT * FROM "title.principals" WHERE tconst='tt0098039';


-- Titulos sin generos 70658
-- Join titles and raiting total 547688
-- Join titles and raiting without nulls 245016
-- Join  wd 869809
-- Join  principals LEFT 3872899 - INNER 3856044

select * from staging.writers_directors where tconst ='tt0097942';

select * from staging.dim_writers where idwriter = 'nm0000464';

select * from staging.dim_genres where genres1_2='Unknow,Unknow'


-- 12 338 928
SELECT title_id,  count(actor_id), count(genres_id), count(director_id), count(writer_id)
FROM staging.fact_rating
where title_id = 2
group by title_id;