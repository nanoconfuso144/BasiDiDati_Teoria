-- restituire il titolo dei film con durata superiore alla durata di Inception
with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception')
select id, official_title
from imdb.movie
where length > ANY (select length from inception_movie);

-- 57 record nel risultato

with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception')
select id, official_title
from imdb.movie
where length > ALL (select length from inception_movie);

-- 8 record nel risultato

-- quando la subquery restituisce più di un risultato ho due opzioni
-- ANY (il record è restituito se il confronto è vero per almeno uno dei valori restituiti dalla subquery)
-- ALL (il record è restituito se il confronto è vero per tutti i valori restituiti dalla subquery)
-- questa versione equivale a usare subquery con ANY
with inception_movie as (
select length
from imdb.movie
where trim(lower(official_title)) = 'inception')
select distinct id, official_title
from imdb.movie inner join inception_movie on movie.length > inception_movie.length;

-- 57 record con distinct
-- 65 record senza distinct 



-- restituire le coppie di attori che hanno recitato insieme in almeno due film diversi


-- selezionare le persone che hanno recitato in film nei quali erano registi


-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti


-- selezionare i film nel cui cast non figurano attori nati in paesi dove il film è stato prodotto


-- selezionare le pellicole prodotte in Italia e Stati Uniti


-- versione con SELF JOIN della medesima query


-- selezionare le pellicole prodotte solo in Italia




-- selezionare il film di durata maggiore/minore
-- operatori aggregati
-- max, min, sum, avg, count

select max(length)
from imdb.movie;

select min(length)
from imdb.movie;

-- versione della query nella quale si restituiscono anche il codice e il titolo della pellicola associata alla durata maggiore
with max_query as (
select max(length) as max_length
from imdb.movie)
select id, official_title 
from imdb.movie
where length = (select max_length from max_query);

-- altra soluzione con with
with max_query as (
select max(length) as max_length
from imdb.movie)
select id, official_title, length
from imdb.movie inner join max_query on movie.length = max_length;

-- soluzione alternativa
select id, official_title, length
from imdb.movie
where length = (select max(length) from imdb.movie); 

-- restituire la durata media delle pellicole
-- come vengono considerati i record con valore null su length?
-- avg è somma delle length / numero dei movie
select avg(length) from imdb.movie
select avg(length) from imdb.movie where length is not null;

-- restituire la durata complessiva delle pellicole del 2010
select sum(length) from imdb.movie where year = '2010';
select * from imdb.movie where year = '2010';

-- restituire il numero di pellicole memorizzate 
select count(*) from imdb.movie;


-- restituire il numero di pellicole per le quali è noto il titolo
select count(*) from imdb.movie where official_title is not null;
select count(official_title) from imdb.movie;

-- restituire il numero di pellicole per le quali è noto l'anno di produzione
select count(*) from imdb.movie where year is not null;
select count(year) from imdb.movie;
-- anni senza duplicati
select count(distinct year) from imdb.movie;

-- restituire il numero di titoli diversi delle pellicole
select count(distinct official_title) from imdb.movie;


-- restituire il numero di pellicole per ogni anno disponibile (con ordinamento)
select year, count(*) as "numero pellicole x anno"
from imdb.movie
group by year
order by year;

-- restituire il numero di pellicole per ogni anno a partire dal 2010 (con ordinamento)
select year, count(*) as "numero pellicole x anno"
from imdb.movie
where year >= '2010'
group by year
order by year;

-- ordinare per numerosità decrescente
select year, count(*) as "numero pellicole x anno"
from imdb.movie
where year >= '2010'
group by year
order by "numero pellicole x anno" DESC;

select year, count(*) as "numero pellicole x anno"
from imdb.movie
where year >= '2010'
group by year
order by 2 DESC;

-- restituire gli anni nei quali ci sono più di 10 film a partire dal 2010

-- restituire per ciascun film il numero di persone coinvolte per ciascun ruolo
select movie, p_role, count(*), count(person), count(distinct person)
from imdb.crew
group by movie, p_role
order by movie;

-- restituire per ciascun film il numero di persone coinvolte
select movie, count(*), count(person), count(distinct person)
from imdb.crew
group by movie
order by movie;


-- restituire la durata media delle pellicole per ogni anno (con ordinamento)
select year, avg(length) as "durata media pellicole x anno"
from imdb.movie
group by year
order by year;


-- restituire il numero di persone per ruolo
select p_role, count(*), count(person) as "numero persone nel ruolo"
from imdb.crew
group by p_role;



