--05/04/2023
--
-- restituire per ogni movie il numero di materiali disponibili
-- material(id, description, kanguage, movie)
select movie, count(*), count(id), count(distinct id), count(description)
from imdb.material
group by movie;

--restituire nell'esercizio precedente anche il titolo della pellicola
select movie, official_title , count(*) as "numero materiali" --senza official title nella clausola di raggruppamento, il dbms andrebbe in confusione perchè ci sono più valori dell'attributo nel gruppo
from imdb.material inner join imdb.movie on movie.id = material.movie 
group by movie, official_title;

--l'ordine con cui si specificano gli attributi di raggruppamento cambia il risultato?
select movie , p_role, count(*)
from imdb.crew
group by p_role, movie --ordine 1
order by movie;

select movie , p_role, count(*)
from imdb.crew
group by movie, p_role -- ordine 2
order by movie;
-- risposta: no

--tutti i movie hanno materiali?
--questa soluzione ci farebbe pensare di sì, ma è un'interpretazione errata, perchè dal join non compaiono nella tabella i movie che non hanno record di materiale
select movie, official_title , count(*) as "numero materiali" --senza official title nella clausola di raggruppamento, il dbms andrebbe in confusione perchè ci sono più valori dell'attributo nel gruppo
from imdb.material inner join imdb.movie on movie.id = material.movie 
group by material.movie, official_title
order by 3 asc;
--risolvo con un right join
--usare count(*) sarebbe sbagliato in questo caso perchè conta i record, ma noi non vogliamo contare i record che hanno material.id uguale a null (cioè film che non hanno materiali)
select movie.id, official_title , count(material.id) as "numero materiali" --senza official title nella clausola di raggruppamento, il dbms andrebbe in confusione perchè ci sono più valori dell'attributo nel gruppo
from imdb.material right join imdb.movie on movie.id = material.movie 
group by movie.id, official_title -- raggruppo su movie.id (e proietto su essa), perchè i material.movie sarebbe null per i movie che non hanno materiale
order by 3 asc;

--per ogni paese restituire il numero di film prodotti
select country.iso3 , count(produced.movie) as "pellicole prodotte"
from imdb.produced right join imdb.country on produced.country = country.iso3
group by country.iso3  
order by 2;

--per ogni persona restituire il numero di film in cui recita e mostrare il given name
-- person e crew
select given_name, count(crew.movie) 
from imdb.crew right join imdb.person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name --è fondamentale in generale raggruppare anche per l'identificatore. in questo caso se raggruppassi solo su given_name, casi di omonimia verreggero contati nello stesso gruppo
order by 2;

--altra soluzione con with
with actors as (
select distinct person, movie
from imdb.crew
where p_role = 'actor'
)
select given_name, count(movie)
from imdb.person left join actors on person.id = actors.person
group by person.id, given_name
order by 2;



--restituire le persone che recitano in più di 3 pellicole
select given_name, count(movie) 
from imdb.crew right join imdb.person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name
having count(movie)>3 --effettivamente clausola di filtro sui gruppi
order by 2;

--altra soluzione
with movie_by_person as (
select given_name, count(movie) as recitazioni
from imdb.crew right join imdb.person on person.id = crew.person and p_role = 'actor'
group by person.id, given_name
)
select given_name, recitazioni
from movie_by_person
where recitazioni>3
order by 2;

--restituire i film con cast più ampio di 10 attori
select movie, count(person)
from imdb.crew
where p_role='actor'
group by movie 
having count(person)>10
order by 2;

--restituire le persone che non hanno mai recitato in un film (da fare a casa)

--restituire le persone che hanno svolto più di un ruolo (anche nel medesimo film)
select person, count(distinct p_role)
from imdb.crew
group by person
having count(distinct p_role)>1
order by 2; 

--restituire le persone che hanno svolto più di un ruolo in film diversi
select person, count(distinct p_role)
from imdb.crew
group by perso
having count(distinct movie)>1 and count(distinct p_role)>1
order by 2; 
--si può fare con self join

--l'attore che ha recitato nel magior numero di film
with count_actors as (
select person, count(movie) as recitazioni
from imdb.crew
where p_role = 'actor'
group by person 
)
select person, count(movie)
from imdb.crew
where p_role = 'actor'
group by person 
having count(movie) = (select max(recitazioni) from count_actors);

--senza with, un po' bruttina
select person, count(movie)
from imdb.crew
where p_role='actor'
group by person
having count(movie) >= all (select count(movie)
from imdb.crew
where p_role = 'actor'
group by person);

--i film con cast(attori) più numeroso della media
with movie_conteggi as( --per ogni film il numero di attori
select movie, count(person) as conteggio
from imdb.crew
where p_role = 'actor'
group by movie
), movie_avg as ( -- valore medio di attori
select avg(conteggio) as media
from movie_conteggi
)
select movie, conteggio, media
from movie_conteggi inner join movie_avg on movie_conteggi.conteggio > movie_avg.media
where conteggio > (select media from movie_avg)
order by conteggio desc;





