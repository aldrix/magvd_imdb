WITH actors_best  AS( SELECT DISTINCT  a.actor_id, a.primary_name, r.average_rating, r.num_votes
FROM pro.fact_rating r
JOIN pro.dim_actors a ON a.actor_id = r.actor_id and r.average_rating > 5
ORDER BY  r.average_rating desc limit 200
)
SELECT a.primary_name AS actor , SUM(a.average_rating * a.num_votes)/SUM(num_votes) as prom, Count(*),SUM(num_votes)
FROM  actors_best a
GROUP BY a.primary_name
 

-- las películas más votadas por los usuarios indicando el número de votos recibidos
-- y la puntuación media
SELECT  t.original_title, r.num_votes,  r.average_rating
FROM pro.fact_rating r
         JOIN pro.dim_titles t ON t.title_id = r.title_id
GROUP BY  t.original_title, r.num_votes, r.average_rating 
ORDER BY r.num_votes DESC
LIMIT  10;




-- la media de puntuaciones por género1
with 
g1 as (SELECT  t.genres1 as genre, SUM(r.num_votes) as votos_totales, SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pre_pro.fact_rating r
         JOIN pre_pro.dim_genres t ON t.genres_id = r.genres_id
where r.num_votes > 0 and t.genres1 != 'Unknow'
GROUP BY  t.genres1),
g2 as (SELECT  t.genres2 as genre, SUM(r.num_votes) as votos_totales, SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pre_pro.fact_rating r
         JOIN pre_pro.dim_genres t ON t.genres_id = r.genres_id
where r.num_votes > 0 and t.genres2 != 'Unknow'
GROUP BY  t.genres2),
g3 as (SELECT  t.genres3 as genre, SUM(r.num_votes) as votos_totales, SUM(r.average_rating * r.num_votes)/SUM(r.num_votes) AS puntuación_media
FROM pre_pro.fact_rating r
         JOIN pre_pro.dim_genres t ON t.genres_id = r.genres_id
where r.num_votes > 0 and t.genres3 != 'Unknow'
GROUP BY  t.genres3)
select g1.genre, g1.votos_totales + g2.votos_totales from g1 full join g2 on g1.genre = g2.genre;






-- el número de películas de cada género1 estrenadas en un periodo determinado
SELECT  g.genres1,  t.release_year, count(t.title_id)
FROM pro.fact_rating r
         JOIN pro.dim_genres g ON g.genres_id = r.genres_id
         JOIN pro.dim_titles t ON t.title_id = r.title_id
WHERE t.release_year is not  null and 1960 < t.release_year and t.release_year < 1980
GROUP BY  g.genres1,  t.release_year
ORDER BY t.release_year DESC
LIMIT  100;





select count(*) from (select dd.primaryName , dd.profession1, dd.profession2, 
dd.profession3 from staging.dim_directors dd) as dir;


update staging.dim_genres set genres1 = 'Unknown' where genres1 = 'Unknow' ;

update staging.dim_genres set genres2 = 'Unknown' where genres2 = 'Unknow' ;

update staging.dim_genres set genres3 = 'Unknown' where genres3 = 'Unknow' ;



update staging.dim_genres set genres1_2 = 
   (case 
		when genres2 != 'Unknown' then concat(genres1, ',',genres2)
		else genres1
		end)
update staging.dim_genres set genres1_3 = concat(genres1, ',',genres3);

update staging.dim_genres set genres2_3 = concat(genres2, ',',genres3);




update staging.dim_genres set genres = concat(genres1, ',',genres2, ',', genres3) where genres3 != 'Unknown';

update staging.dim_genres set genres = concat(genres1, ',',genres2) where genres3 = 'Unknown';

update staging.dim_genres set genres = genres1 where genres2 = 'Unknown';




select concat(genres,', ', genres3) from staging.d_genres dg limit 100;


select * from staging.d_genres dg where genres2 like '%know%';

select * from pre_pro.dim_directors dd where dd.director_id =120313;


select * from pre_pro.dim_writers dw  where dw.writer_id = 65760;
65760

select count(*) from staging.dim_directors dd where dd."primaryName" is null;
select * from staging.dim_writers dw  where dw."primaryName" is null;

select distinct dt, fr.average_rating, fr.num_votes from pre_pro.fact_rating fr inner join pre_pro.dim_directors dd on fr.director_id = dd.director_id  
											inner join pre_pro.dim_writers dw on fr.writer_id = dw.writer_id  
											inner join pre_pro.dim_titles dt on dt.title_id = fr.title_id 
where dd.primary_name is null or dw.primary_name is null ;



select distinct dt, fr.average_rating, fr.num_votes from staging.fact_rating fr inner join staging.dim_directors dd on fr.director_id = dd.director_id  
											inner join staging.dim_writers dw on fr.writer_id = dw.writer_id  
											inner join staging.dim_titles dt on dt.title_id = fr.title_id 
where dd."primaryName" is null or dw."primaryName" is null ;







select distinct dt.original_title, dd.primary_name from pre_pro.fact_rating fr inner join pre_pro.dim_directors dd on fr.director_id = dd.director_id  
											inner join pre_pro.dim_writers dw on fr.writer_id = dw.writer_id  
											inner join pre_pro.dim_titles dt on dt.title_id = fr.title_id 
where dd.primary_name = dw.primary_name;

(224020,"Stan Derain",,,producer,writer,director)


select count(*) from pre_pro.fact_rating fr join pre_pro.dim_writers dw on fr.writer_id = dw.writer_id  
where dw.primary_name is null;



select * from staging.dim_writers dw where dw."primaryName" = 'Tasha Sharp' ;


select distinct fr.title_id from pre_pro.fact_rating fr where fr.director_id =120313;

32453

select * from pre_pro.dim_titles dt where dt.title_id = 231141;

select concat(genres,', ', genres3) from staging.d_genres dg limit 100;

nm6312742
nm6499799
nm6434131




select iddirector, count(*) from staging.dim_directors dd group by iddirector having count(*)>1 ;


select * from staging.dim_directors dd where iddirector = '590543';
select count(*) from staging.d_directors dd wd where wd.


select * from staging.d_writers dw where primary_name is null;

select count(*) from staging.d_writers dw;

select count(distinct dw.writer ) from staging.d_writers dw ; 



select * from staging.d_directors dd where primary_name is null;

select count(*) from staging.d_directors dd;

select count(distinct dd.director ) from staging.d_directors dd ; 

-- Checking for actors
select * from staging.dim_actors da limit 10;

select count(distinct da.idactor) from staging.d_actors da;


select count(distinct idactor) from staging.d_actors da ;
-- 589845

select count(distinct idactor) from staging.d_actors da where "primaryName" is null;
-- 589845


WITH actors  AS(select distinct idactor from staging.d_actors da)
select count(*) from actors ;
;
--589846




--Vista de tabla de actores
select distinct idactor as actor, "primaryName" as primary_name, "birthYear" as birth_year, "deathYear" as death_year,
alternativeprofession1 as profession1, alternativeprofession2 as profession2, alternativeprofession3 as profession3,
"knownForTitles" as know_for_titles
from staging.d_actors da;





-- Checking for escritores
select * from staging.d_writers dw limit 10;


select count(*) from staging.d_writers dw;
-- 283519


select count(distinct writer) from staging.d_writers da ;
-- 283519

select count( writer ) from staging.d_writers da where primary_name is null or profession1 is null or profession2 is null or profession3 is null;
-- 0



-- Chequeo de directores


-- Checking for escritores
select * from staging.d_directors dd limit 10;


select count(*) from staging.d_directors dw;
-- 205018


select count(distinct director ) from staging.d_directors da ;
-- 205018

select count( director ) from staging.d_directors da where primary_name is null or profession1 is null or profession2 is null or profession3 is null;
-- 0



                          SELECT DISTINCT
                              t.title_id
                            ,t.original_title
                            ,t.idpelicula
                            ,(CASE WHEN g.genres IS NULL
                                       THEN 'Unknown,Unknown,Unknown'
                                   ELSE  g.genres
                              END) AS genres
                                        ,(CASE WHEN  a.actor IS NULL
                                                   THEN 'Unknown'
                                               ELSE  a.actor
                              END) AS  actor
                                        ,(CASE WHEN d.director IS NULL
                                                   THEN 'Unknown'
                                               ELSE  d.director
                              END) AS director
                                        ,(CASE WHEN w.writer IS NULL
                                                   THEN 'Unknown'
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
                                   LEFT JOIN staging.dim_actors a ON a.actor = a1.idactor;








