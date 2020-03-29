# :To execute these commands tou need to have installed postgres 

#!/bin/bash
psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.title.akas(ordering, title, region, language, types, attributes, isoriginaltitle) FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.akas.tsv' DELIMITER E'\t\';"

psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.title.basics(titletype, primarytitle, originaltitle, isadult, startyear, endyear, runtimeminutes, genres) FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.basics.tsv' DELIMITER E'\t\';"

psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.title.crew(tconst, directors, writers) FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.crew.tsv' DELIMITER E'\t\';"

psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.title.episode(tconst, parenttconst, seasonnumber, episodenumber) FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.episode.tsv' DELIMITER E'\t\';"

psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.title.principals(tconst, ordering, nconst, category, job, characters)  FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.principals.tsv' DELIMITER E'\t\';"

psql -h 127.0.0.1 -U postgres -d magvd_imdb -c "copy public.public.title.ratings(tconst, averagerating, numvotes) FROM '/home/shamuel/unizar/magvd_imdb/imdb_datasetfile/title.ratings.tsv' DELIMITER E'\t\';"









