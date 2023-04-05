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



