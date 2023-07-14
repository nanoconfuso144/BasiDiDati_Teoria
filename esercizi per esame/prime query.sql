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


