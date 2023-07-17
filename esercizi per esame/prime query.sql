--selezionare il titolo delle pellicole del 2010
select official_title 
from imdb.movie
where year = '2012';

-- selezionare tutti gli attributi delle pellicole di durata compresa fra una e due ore (estremi inclusi) realizzate in anni diversi dal 2010

select *
from imdb.movie
where length <=120 and length >= 60 and year <> '2010';

-- selezionare le pellicole con valore di year definito

select id, year 
from imdb.movie
where year is not null;

-- selezionare i titoli deii movie con genere Drama, Comedy, o Thriller
-- eliminare i duplicati dal risultato e ordinare il risultato in modo decrescente (desc)
select distinct id, official_title
from imdb.movie m inner join imdb.genre g on m.id = g.movie
where genre in ('Drama', 'Comedy', 'Thriller')
order by id desc;

select distinct id, official_title
from imdb.movie m inner join imdb.genre g on m.id = g.movie
where genre in ('Drama', 'Comedy', 'Thriller')
order by id;

select distinct id, official_title
from imdb.movie m inner join imdb.genre g on m.id = g.movie
where genre in ('Drama', 'Comedy', 'Thriller')
order by official_title desc;

-- selezionare pellicole che hanno "murder" nel titolo
-- operatore like prevede due segnaposto
-- %: stringa di qualsiasi lunghezza
-- _: stringa di lunghezza un carattere

select id, official_title
from imdb.movie
where lower(official_title) = '%murder%';

-- selezionare i paesi nei quali sono state distribuite le pellicole del 2010 (si restituisca anche il titolo della 
-- pellicola - sia quello ufficiale, sia quello usato nella distribuzione dove presente)

select c.name as "paese", c.iso3 as "codice paese", official_title as "titolo ufficiale", title as "titolo di rilascio"
from imdb.movie m inner join imdb.released r on  m.id = r.movie inner join imdb.country c on c.iso3 = r.country 
where m.year = '2010'
order by c.iso3;

-- selezionare le persone che sono decedute in un paese diverso da quello di nascita
select b.person 
from imdb.location b inner join imdb.location d on b.person = d.person and b.d_role <> d.d_role
where b.d_role = 'B' and d.d_role = 'D';

-- selezionare i film che non hanno materiali associati
select id, official_title 
from imdb.movie
except 
select distinct m.id, official_title 
from imdb.movie m inner join imdb.material b on m.id = b.movie; 


-- restituire il titolo dei film con durata superiore alla durata di Inception
with inception_movie as (
select length
from imdb.movie m1
where trim(lower(m1.official_title)) ='inception' 
)
select id, official_title, length 
from imdb.movie m2
where length > any(select length from inception_movie)
order by length;

-- restituire le coppie di attori che hanno recitato insieme in almeno due film diversi
with coppie as (
select c1.person as "p1", c2.person as "p2", c1.movie 
from imdb.crew c1 inner join imdb.crew c2 on c1.movie = c2.movie and c1.person <> c2.person
where c1.p_role ='actor' and c2.p_role = 'actor')
select distinct co1.p1, co1.p2
from coppie co1 inner join coppie co2 on co1.p1 = co2.p1 and co1.p2 = co2.p2 and co1.movie <> co2.movie;


-- selezionare le persone che hanno recitato in film nei quali erano registi
with registi as(
select person, movie
from imdb.crew
where p_role = 'director'
)
select registi.person
from registi inner join imdb.crew on registi.person = crew.person
where crew.p_role = 'actor';

-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti

	--film rilasciati nei paesi in cui sono stati prodotti
with prod_ril as(
select movie
from imdb.released r
where r.country = any(select country from imdb.produced p where p.movie = r.movie)
)
select distinct released.movie
from imdb.released left join prod_ril on released.movie = prod_ril.movie
where prod_ril.movie is null;

-- restituire il numero di pellicole per ogni anno disponibile (con ordinamento)

select year, count(*) as "pellicole per anno"
from  imdb.movie m 
group by year 
order by "pellicole per anno" desc;

-- restituire gli anni nei quali ci sono più di 10 film a partire dal 2010

with film_per_anni as(
select year, count(*) as "pellicole per anno"
from  imdb.movie m 
group by year 
)
select year
from film_per_anni
where "pellicole per anno" > 10;

-- restituire per ciascun film il numero di persone coinvolte per ciascun ruolo

select movie, p_role, count(*), count(person), count(distinct person)
from imdb.crew
group by movie, p_role;

-- restituire la durata media delle pellicole per ogni anno (con ordinamento)

select year, avg(length) 
from imdb.movie
group by year
order by year desc;

-- restituire il numero di persone per ruolo

select p_role, count(distinct person) as "numero"
from imdb.crew
group by p_role
order by "numero";

-- restituire per ogni movie il numero di materiali disponibili e il titolo del film
-- material(id, description, language, movie)

select mat.movie, mov.official_title, count(mat.id) as "materiale",
from imdb.material mat right join imdb.movie mov on mat.movie = mov.id
group by mat.movie, mov.official_title
order by 3 desc;

-- restituire le persone che recitano in più di 10 pellicole

select c.person, count(c.movie) "n.film"
from imdb.crew c
where c.p_role = 'actor'
group by c.person
having count(c.movie)>10;

-- restituire i film con cast più ampio di 10 attori

select movie, count(person) 
from imdb.crew c 
where p_role = 'actor'
group by movie
having count(person) > 10 
order by 2 desc;

-- restituire le persone che non hanno mai recitato in un film
with hanno_recitato as(
select person, count(movie) as "film"
from imdb.crew c 
where p_role = 'actor'
group by person
)
select p.id, p.given_name
from imdb.person p left join hanno_recitato h on p.id = h.person
where h."film" is null;

-- selezionare le persone che hanno recitato in tutti i film di genere Crime

select p.id
from imdb.person p
where not exists (
	select *
	from imdb.genre g
	where g.genre = 'Crime' and not exists (
		select *
		from imdb.crew c
		where c.p_role ='actor' and c.movie = g.movie and c.person = p.id 
	)
);

-- selezionare i film con cast più numeroso della media dei film del medesimo genere
with media_generi as (
select g.genre, count(c.person)/count(distinct c.movie)  as "media"  
from imdb.genre g inner join imdb.crew c on g.movie = c.movie
where c.p_role = 'actor'
group by g.genre
)
select distinct g2.movie 
from media_generi mg inner join imdb.genre g2 on mg.genre = g2.genre
where mg."media" <= all(
	select count(distinct c1.person)
	from imdb.crew c1 
	where c1.p_role = 'actor' and c1.movie = g2.movie
	group by movie
)
order by g2.movie;
	




























