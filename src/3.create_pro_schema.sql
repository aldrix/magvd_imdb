create schema pro;

comment on schema pro is 'production datawarehouse schema';

alter schema pro owner to postgres;

create table if not exists dim_genres
(
	genres_id serial not null
		constraint dim_genres_pkey
			primary key,
	genres_all text,
	genres1_2 text,
	genres1_3 text,
	genres2_3 text,
	genres1 text,
	genres2 text,
	genres3 text
);

alter table dim_genres owner to postgres;

create table if not exists dim_directors
(
	director_id serial not null
		constraint dim_directors_pkey
			primary key,
	iddirector text,
	"primaryName" varchar,
	"birthYear" integer,
	"deathYear" integer,
	profession1 text,
	profession2 text,
	profession3 text
);

alter table dim_directors owner to postgres;

create table if not exists dim_writers
(
	writer_id serial not null
		constraint dim_writers_pkey
			primary key,
	idwriter text,
	"primaryName" varchar,
	"birthYear" integer,
	"deathYear" integer,
	profession1 text,
	profession2 text,
	profession3 text
);

alter table dim_writers owner to postgres;

create table if not exists dim_titles
(
	title_id serial not null
		constraint dim_titles_pkey
			primary key,
	idpelicula varchar,
	primary_title text,
	original_title text,
	"isAdult" boolean,
	release_year integer,
	runtime_minutes integer,
	genres text
);

alter table dim_titles owner to postgres;

create table if not exists dim_actors
(
	actor_id serial not null
		constraint dim_actors_pkey
			primary key,
	idactor varchar,
	"primaryName" varchar,
	"birthYear" integer,
	"deathYear" integer,
	profession1 text,
	profession2 text,
	profession3 text,
	known_fo_titles text,
	job text
);

alter table dim_actors owner to postgres;

create table if not exists fact_rating
(
	title_id integer not null
		constraint title_id_fk
			references dim_titles,
	genres_id integer not null
		constraint genres_id_fk
			references dim_genres,
	actor_id integer not null
		constraint actor_id_fk
			references dim_actors,
	director_id integer not null
		constraint director_id_fk
			references dim_directors,
	writer_id integer not null
		constraint writer_id_fk
			references dim_writers,
	average_rating numeric,
	num_votes integer,
	constraint fact_rating_pkey
		primary key (title_id, genres_id, actor_id, director_id, writer_id)
);

alter table fact_rating owner to postgres;

