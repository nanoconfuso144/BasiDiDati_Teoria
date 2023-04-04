--04/03/2023
--AGGREGAZIONI

--selezionare il film di durata maggiore/minore
--si utilizzano gli operatori aggregati
-- max(massimo su un attributo), min(minimo su un attributo), sum(), avg, count

select max(length) --NB non sto ancora selezionando il film
from imdb.movie;

select min(length) --NB non sto ancora selezionando il film
from imdb.movie;

with max_query as (
select max(length) as max_length
from imdb.movie
)
select id, official_title 
from imdb.movie
where length = (select max_length from max_query);

--soluzione senza with
select id, official_title
from imdb.movie
where length = (select max(length) from imdb.movie);