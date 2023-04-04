--04/03/2023
--AGGREGAZIONI

--selezionare il film di durata maggiore/minore
--si utilizzano gli operatori aggregati
-- max(massimo su un attributo), min(minimo su un attributo), sum(), avg, count
--NB: max e min ritornano un solo valore (massimo o minimo) anche se ci sono più record con tale valore

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

--restituire i titoli dei film con durata superiore alla durata di Inseption
with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception'
)
select id, official_title
from imdb.movie
where length > (select length from inception_movie);

--alternativamente
with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception'
)
select id, official_title
from imdb.movie inner join inception_movie on movie.length > inception_movie.length;


--devo stare però attento: quando la subquey restituisce più di un risultato (< è un operatore scalare!)
--operatori: ANY o ALL

-- ALL: il record è restituito se il confronto è vero per tutti i valori restituiti dalla query
--ANY: il record è restituito se il confronto è vero per almeno uno dei valori restituito dalla query
--any filtra i duplicati

with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception'
)
select id, official_title
from imdb.movie
where length > all (select length from inception_movie);

with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception'
)
select id, official_title
from imdb.movie
where length > all (select length from inception_movie);

with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception'
)
select id, official_title
from imdb.movie
where length > any (select length from inception_movie);

-- la soluzione precedente con il join (con select distinct), equivale alla soluzione con operatore ANY


--restituire la durata media delle pellicole
select avg(length)
from imdb.movie;

--restituire la durata complessiva delle pellicole del 2010
select sum(length) --vengono ignorati i valori null
from imdb.movie
where year = '2010';

--restituire il numero di pellicole memorizzare
select count(*) --count(*) restituisce il numero totale dei record
from imdb.movie;

--restituire il numero di pellicole per cui il titolo è noto
select count(*)
from imdb.movie
where official_title is not null;

--restituire il numero di pellicole per cui l'anno di produzione è noto
select count(*)
from imdb.movie
where year is not null;

--alternativamente
select count(year) -- year(attributo) conta i record con valore non null su quell'attributo
from imdb.movie;

--restituire il numero di anni in cui è stata prodotta una pellicola
select count(distinct year) -- year(distinct attributo) conta il numero di diversi valori non null dell'attributo su tutti i record
from imdb.movie;


--restituire il numero di pellicole per ogni anno disponibile (con ordinamento)
--bisogna contare su dei "raggruppamenti" di pellicole -> raggruppare le pellicole per anno di produzione

select year, count(*) as "numero pellicole per anno" --la count è applicata su ciascun gruppo
from imdb.movie
group by year --permette il raggruppamento dei record nella from
order by year;

--restituire il numero di pellicole per ogni anno a partire dal 2012 (con ordinamento)
select year, count(*) as "numero pellicole per anno" --la count è applicata su ciascun gruppo
from imdb.movie
where year>='2012'
group by year --permette il raggruppamento dei record nella from
order by year;








