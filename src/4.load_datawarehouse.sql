
WITH temp_count AS (
    SELECT
                        title_id
-- ,genres_id
-- ,actor_id
-- ,director_id
-- ,writer_rating
                         ,r.averagerating AS average_rating
                         ,r.numvotes AS num_votes
                    FROM staging.dim_titles t
                             LEFT JOIN "title.ratings" r ON t.idpelicula = r.tconst
                             LEFT JOIN "title.principals" p ON p.tconst = t.idpelicula
--                              LEFT JOIN staging.writers_directors wd ON wd.tconst = t.idpelicula
--                              LEFT JOIN staging.dim_writers w ON w.idwriter = t.idpelicula
--                              LEFT JOIN staging.dim_directors d ON d.iddirector = t.idpelicula
--                              LEFT JOIN staging.dim_actors a ON a.idactor = t.idpelicula
--                              LEFT JOIN staging.dim_genres g ON g.genres_all = t.genres
    --                     r.averagerating IS NOT NULL
)SELECT count(*)
FROM temp_count
;

-- Join titles and raiting with nulls 547688
-- Join titles and raiting without nulls 245016
-- Join  wd 869809

