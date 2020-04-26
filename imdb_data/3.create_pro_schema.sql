--/---------------------------------------------------------/
--/---------------- CREATE SCHEMA PRO   --------------------/
--/---------------------------------------------------------/
create schema pro;

comment on schema pro is 'production datawarehouse schema';

alter schema pro owner to postgres;

--/---------------------------------------------------------/
--/---------------- CREATE TABLES IN PRO  ------------------/
--/---------------------------------------------------------/
create table if not exists pro.dim_genres
(
	genres_id serial not null
		constraint dim_genres_pkey
			primary key,
	genres text,
	genres1_2 text,
	genres1_3 text,
	genres2_3 text,
	genres1 text,
	genres2 text,
	genres3 text
);

alter table pro.dim_genres owner to postgres;

create table if not exists pro.dim_directors
(
	director_id serial not null
		constraint dim_directors_pkey
			primary key,
	director text,
	"primary_name" varchar,
	"birth_year" integer,
	"death_year" integer,
	profession1 text,
	profession2 text,
	profession3 text
);

alter table pro.dim_directors owner to postgres;

create table if not exists pro.dim_writers
(
	writer_id serial not null
		constraint dim_writers_pkey
			primary key,
	writer text,
	"primary_name" varchar,
	"birth_year" integer,
	"death_year" integer,
	profession1 text,
	profession2 text,
	profession3 text
);

alter table pro.dim_writers owner to postgres;

create table if not exists pro.dim_titles
(
	title_id serial not null
		constraint dim_titles_pkey
			primary key,
	title varchar,
	primary_title text,
	original_title text,
	"is_adult" boolean,
	release_year integer,
	runtime_minutes integer
);

alter table pro.dim_titles owner to postgres;

create table if not exists pro.dim_actors
(
	actor_id serial not null
		constraint dim_actors_pkey
			primary key,
	actor varchar,
	"primary_name" varchar,
	"birth_year" integer,
	"death_year" integer,
	profession1 text,
	profession2 text,
	profession3 text,
	known_for_titles text,
    gender text
);

alter table pro.dim_actors owner to postgres;

create table if not exists pro.fact_rating
(
    title_id integer not null
        constraint title_id_fk
            references pro.dim_titles,
    genres_id integer not null
        constraint genres_id_fk
            references pro.dim_genres,
    actor_id integer not null
        constraint actor_id_fk
            references pro.dim_actors,
    director_id integer not null
        constraint director_id_fk
            references pro.dim_directors,
    writer_id integer not null
        constraint writer_id_fk
            references pro.dim_writers,
    average_rating numeric,
    num_votes integer,
    constraint fact_rating_pkey
        primary key (title_id, genres_id, actor_id, director_id, writer_id)
);

alter table pro.fact_rating owner to postgres;

