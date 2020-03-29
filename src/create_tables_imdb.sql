--/---------------------------------------------------------/
--/------------------ CREATE DATABASE   --------------------/
--/---------------------------------------------------------/

-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

COMMENT ON SCHEMA public IS 'standard public schema';


--/---------------------------------------------------------/
--/-------------------- CREATE TABLES   --------------------/
--/---------------------------------------------------------/

-- public."title.akas" definition

-- Drop table

-- DROP TABLE public."title.akas";

CREATE TABLE public."title.akas" (
	"ordering" int4 NULL,
	title text NULL,
	region varchar NULL,
	"language" varchar NULL,
	"types" varchar NULL,
	"attributes" text NULL,
	isoriginaltitle bool NULL
);



-- public."title.basics" definition

-- Drop table

-- DROP TABLE public."title.basics";

CREATE TABLE public."title.basics" (
	titletype varchar NULL,
	primarytitle text NULL,
	originaltitle text NULL,
	isadult bool NULL,
	startyear int4 NULL,
	endyear int4 NULL,
	runtimeminutes int4 NULL,
	genres text NULL
);

-- public."title.crew" definition

-- Drop table

-- DROP TABLE public."title.crew";

CREATE TABLE public."title.crew" (
	tconst varchar NOT NULL,
	directors text NULL,
	writers text NULL,
	CONSTRAINT title_crew_pk PRIMARY KEY (tconst)
);


-- public."title.episode" definition

-- Drop table

-- DROP TABLE public."title.episode";

CREATE TABLE public."title.episode" (
	tconst varchar NOT NULL,
	parenttconst text NULL,
	seasonnumber int4 NULL,
	episodenumber int4 NULL,
	CONSTRAINT title_episode_pk PRIMARY KEY (tconst)
);


-- public."title.principals" definition

-- Drop table

-- DROP TABLE public."title.principals";

CREATE TABLE public."title.principals" (
	tconst varchar NULL,
	"ordering" int4 NULL,
	nconst varchar NULL,
	category varchar NULL,
	job text NULL,
	"characters" text NULL
);

-- public."title.ratings" definition

-- Drop table

-- DROP TABLE public."title.ratings";

CREATE TABLE public."title.ratings" (
	tconst varchar NOT NULL,
	averagerating numeric NULL,
	numvotes int4 NULL,
	CONSTRAINT title_ratings_pk PRIMARY KEY (tconst)
);
