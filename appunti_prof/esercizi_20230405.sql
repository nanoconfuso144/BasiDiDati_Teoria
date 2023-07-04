-- restituire per ogni movie il numero di materiali disponibili
-- material(id, description, language, movie)
select movie, count(*) as "numero materiali"
from imdb.material
group by movie;

-- restituire nell'esercizio precedente anche il titolo dei film
select movie.id, official_title, count(*), count(material.id) as "numero materiali"
from imdb.material right join imdb.movie on movie.id = material.movie
group by movie.id, official_title
order by 4 ASC;

-- restituire per ogni paese il numero di film prodotti in quel country
select country.iso3, count(produced.movie)
from imdb.produced right join imdb.country on produced.country = country.iso3
group by country.iso3
order by 2;

-- per ogni persona restituire il numero di film in cui recita e mostrare il given_name
-- il comando explain mostra il piano di esecuzione della query con i costi di esecuzione
-- https://www.postgresql.org/docs/current/sql-explain.html
EXPLAIN (FORMAT JSON) select given_name, count(movie)
from crew right join person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name
order by 2;

-- altra soluzione con with
EXPLAIN (FORMAT JSON) with actors as (
select distinct person, movie
from imdb.crew
where p_role = 'actor'
)
select given_name, count(movie)
from imdb.person left join actors on person.id = actors.person
group by person.id, given_name
order by 2

-- restituire le persone che recitano in più di 10 pellicole
select given_name, count(movie)
from crew right join person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name
having count(movie) > 10
order by 2;

-- altra soluzione
with movie_by_person as (
select given_name, count(movie) as recitazioni
from crew right join person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name)
select given_name, recitazioni
from movie_by_person
where recitazioni > 10
order by 2;

-- restituire i film con cast più ampio di 10 attori
select movie, count(person)
from imdb.crew 
where p_role ='actor'
group by movie
having count(person) > 10;

-- restituire le persone che non hanno mai recitato in un film


-- restituire le persone che hanno svolto più di un ruolo (anche nel medesimo film)
-- person 003 è stato attore nel film ABC
-- person 003 è stata regista nel film ABC
select person, count(distinct p_role)
from imdb.crew
group by person 
having count(distinct p_role) > 1;

-- restituire le persone che hanno svolto più di un ruolo (in film diversi)
-- person 003 è stato attore nel film ABC
-- person 003 è stata regista nel film BCD
-- person 003 è stato attore nel film BCD
select person, count(distinct movie), count(distinct p_role)
from imdb.crew
group by person
having count(distinct movie) > 1 and count(distinct p_role) > 1;

-- soluzione con self join?


-- restituire il miglior rating di ciascun film


-- selezionare l'attore che ha recitato nel maggior numero di film
with count_actors as (
select count(movie) as recitazioni
from imdb.crew
where p_role = 'actor'
group by person
)
select person
from imdb.crew
where p_role = 'actor'
group by person 
having count(movie) = (select max(recitazioni) from count_actors);


-- senza with
select person, given_name
from imdb.crew inner join person on person.id = crew.person
where p_role = 'actor'
group by person, given_name
having count(movie) >=ALL (select count(movie) as recitazioni
from imdb.crew
where p_role = 'actor'
group by person);

-- con limit
select person, given_name
from imdb.crew inner join person on person.id = crew.person
where p_role = 'actor'
group by person, given_name
having count(movie) = (select count(movie) as recitazioni
from imdb.crew
where p_role = 'actor'
group by person
order by 1 DESC
limit 1);

-- selezionare i film con cast (attori) più numeroso della media
with movie_conteggi as ( -- per ogni film, il numero di attori
select movie, count(person) as conteggio
from imdb.crew
where p_role = 'actor'
group by movie
), movie_avg as ( -- valore medio di attori
select avg(conteggio) as media
from movie_conteggi)
select movie, conteggio
from movie_conteggi
where conteggio > (select media from movie_avg)
order by conteggio;

-- soluzione con media nel risultato
with movie_conteggi as ( -- per ogni film, il numero di attori
select movie, count(person) as conteggio
from imdb.crew
where p_role = 'actor'
group by movie
), movie_avg as ( -- valore medio di attori
select avg(conteggio) as media
from movie_conteggi)
select movie, conteggio, media
from movie_conteggi inner join movie_avg on movie_conteggi.conteggio > movie_avg.media
order by conteggio;


-- selezionare i film con cast più numeroso della media dei film del medesimo genere


-- selezionare il titolo dei film che hanno valutazioni superiori alla media delle valutazioni dei film prodotti nel medesimo anno


-- selezionare le persone che hanno recitato in tutti i film di genere Crime


-- selezionare i film che sono stati distribuiti in tutti i paesi

