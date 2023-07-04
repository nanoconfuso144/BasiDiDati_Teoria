-- selezionare le persone che sono decedute in un paese diverso da quello di nascita
select lbirth.person, lbirth.country as "paese nascita", ldeath.country as "paese decesso"
from imdb.location lbirth inner join imdb.location ldeath on lbirth.person = ldeath.person and lbirth.country <> ldeath.country
where lbirth.d_role = 'B' and ldeath.d_role = 'D' 

-- nella query precedente mostrare anche il nome della persona
select lbirth.person, given_name, lbirth.country as "paese nascita", ldeath.country as "paese decesso"
from imdb.location lbirth inner join imdb.location ldeath on lbirth.person = ldeath.person and lbirth.country <> ldeath.country inner join imdb.person on person.id = lbirth.person
where lbirth.d_role = 'B' and ldeath.d_role = 'D' 


-- selezionare i film che non hanno materiali associati
-- outer join 
select movie.id, official_title
from imdb.movie left join imdb.material on movie.id = material.movie
where material.movie is null;

select * from imdb.movie 
where official_title = 'Marnie';

-- soluzione con sottrazione (except)
-- prima query (A): la totalità dei film
select id, official_title
from imdb.movie
except
-- seconda query (B): i movie con materiali associati
select distinct movie.id, official_title
from imdb.movie inner join imdb.material on movie.id = material.movie;

-- soluzione con query nidificata (meno performante)
select id, official_title
from imdb.movie
where id not in (select distinct movie from imdb.material);

-- selezionare i paesi nei quali non sono prodotti film


-- selezionare i film per i quali esistono materiali multimediali o materiali testuali di qualche genere
-- material (id, description, language, movie)
-- text(material, content)
-- multimedia(material, url, runtime, resolution, type)
select distinct movie
from imdb.material left join imdb.text on material.id = text.material left join imdb.multimedia on material.id = multimedia.material
where text.material is not null or multimedia.material is not null;

-- union
select distinct movie -- query A
from imdb.material inner join imdb.text on material.id = text.material
union
select distinct movie -- query B
from imdb.material inner join imdb.multimedia on material.id = multimedia.material;

-- union restituisce un record se appartiene al risultato di query A o di query B
-- se il record appartiene sia al risultato di A e di B viene restituito una volta sola

-- union restituisce i record di A u B (i record nell'intersezione compaiono una volta sola)
-- union all restituisce tutti i record di A u B. I record nell'intersezione compaiono due volte nel risultato

-- si svolga lo stesso esercizio per restituire i movie associati a un material di tipo text o un material di tipo multimedia, ma non entrambi (or esclusivo)

-- sottraggo l'intersezione dall'unione di A, B
(select distinct movie -- query A
from imdb.material inner join imdb.text on material.id = text.material
union
select distinct movie -- query B
from imdb.material inner join imdb.multimedia on material.id = multimedia.material)
except
(select distinct movie -- query A
from imdb.material inner join imdb.text on material.id = text.material
intersect
select distinct movie -- query B
from imdb.material inner join imdb.multimedia on material.id = multimedia.material);

-- soluzione con costrutto with (CTE - Common Table Expression)
with movie_union as (
select distinct movie -- query A
from imdb.material inner join imdb.text on material.id = text.material
union
select distinct movie -- query B
from imdb.material inner join imdb.multimedia on material.id = multimedia.material),
movie_intersect as (
select distinct movie -- query A
from imdb.material inner join imdb.text on material.id = text.material
intersect
select distinct movie -- query B
from imdb.material inner join imdb.multimedia on material.id = multimedia.material
)
select movie 
from movie_union
except
select movie 
from movie_intersect;

-- si può risolvere con outer join? 


-- selezionare i film per i quali esistono materiali multimediali e materiali testuali di qualche genere (sia testuali sia multimediali)


-- restituire il titolo dei film con durata superiore alla durata di Inception


-- restituire le coppie di attori che hanno recitato insieme in almeno due film diversi


-- selezionare le persone che hanno recitato in film nei quali erano registi


-- selezionare le pellicole prodotte in Italia e Stati Uniti
-- versione con SELF JOIN della medesima queryù
select pit.movie, pit.country, pus.country
from imdb.produced pit inner join imdb.produced pus on pit.movie = pus.movie 
where pit.country = 'ITA' and pus.country = 'USA';

-- versione con filtro sul nome per esteso del paese
select pit.movie, pit.country, cit.name, pus.country, cus.name
from imdb.country cit inner join imdb.produced pit on cit.iso3 = pit.country inner join imdb.produced pus on pit.movie = pus.movie inner join imdb.country cus on pus.country = cus.iso3
where cit.name = 'Italy' and cus.name = 'United States';

-- soluzione con vista
create or replace view imdb.p_country as (
select movie, name as c_name 
from imdb.country inner join imdb.produced on country.iso3 = produced.country);

select * from imdb.p_country;

select pit.movie, pit.c_name, pus.c_name
from imdb.p_country pit inner join imdb.p_country pus on pit.movie = pus.movie
where pit.c_name = 'Italy' and pus.c_name = 'United States';

-- soluzione con intersect
select movie
from imdb.produced
where country = 'ITA'
intersect
select movie
from imdb.produced
where country = 'USA';

-- soluzione con intersect usando la vista p_country
select movie
from imdb.p_country
where c_name = 'Italy'
intersect
select movie
from imdb.p_country
where c_name = 'United States';

-- versione con query nidificata (soluzione meno efficiente delle precedenti)
select movie
from imdb.produced
where country = 'ITA' and 
movie in
(select movie
from imdb.produced
where country = 'USA');


-- selezionare le pellicole prodotte solo in Italia
-- solo in Italia significa che esiste un record del movie con country = 'ITA' and no esistono record del medesimo movie con country <> 'ITA'
select movie
from imdb.produced
where country = 'ITA'
except
select movie
from imdb.produced
where country <> 'ITA'

-- soluzione con outer join
select *
from imdb.produced pita left join imdb.produced npita on pita.movie = npita.movie and npita.country <> 'ITA'
where pita.country = 'ITA' and npita.movie is null;  

-- soluzione alternativa
with ita_movies as (
select movie
from imdb.produced
where country = 'ITA'), 
nonita_movies as (
select movie
from imdb.produced
where country <> 'ITA')
select ita_movies.movie
from ita_movies left join nonita_movies on ita_movies.movie = nonita_movies.movie
where nonita_movies.movie is null;
