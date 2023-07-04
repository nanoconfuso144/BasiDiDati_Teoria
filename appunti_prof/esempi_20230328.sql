-- selezionare il titolo delle pellicole del 2010
select official_title
from imdb.movie
where year = '2010';

-- selezionare tutti gli attributi delle pellicole del 2010 di durata superiore all'ora
select *
from imdb.movie
where year = '2010' and length > 60;

-- selezionare tutti gli attributi delle pellicole del 2010 di durata compresa fra una e due ore
select *
from imdb.movie
where year = '2010' and length >= 60 and length <= 120;

select *
from imdb.movie
where year = '2010' and length between 60 and 120;

-- selezionare tutti gli attributi delle pellicole di durata compresa fra una e due ore (estremi inclusi) realizzate in anni diversi dal 2010
select *
from imdb.movie
where year <> '2010' and length between 60 and 120;


select *
from imdb.movie
where not(year = '2010') and length between 60 and 120;


-- selezionare le pellicole prive di year
select * 
from imdb.movie
where year is null;

-- selezionare le pellicole con valore di year definito
select * 
from imdb.movie
where year is not null;


-- esempio con operatore IN 
-- selezionare i movie con genere Drama, Comedy, o Thriller
select movie
from imdb.genre
where genre = 'Drama' or genre = 'Comedy' or genre = 'Thriller';

-- eliminare i duplicati dal risultato e ordinare il risultato in modo decrescente (desc)
select distinct movie
from imdb.genre
where genre = 'Drama' or genre = 'Comedy' or genre = 'Thriller'
order by movie desc;

-- versione con ordinamento crescente 
select distinct movie
from imdb.genre
where genre = 'Drama' or genre = 'Comedy' or genre = 'Thriller'
order by movie ASC; -- ASC è opzionale perchè caso di default

-- soluzione alternativa con operatore IN 
select distinct movie
from imdb.genre
where genre.genre in ('Drama', 'Comedy', 'Thriller')
order by movie ASC;

-- selezionare le persone delle quali si conosce la data di decesso
select id, given_name
from imdb.person
where death_date is not null;

-- esercizio analogo per coloro di cui non si conosce la data di decesso
select id, given_name
from imdb.person
where death_date is null;

select *
from imdb.person
where death_date is null;


-- selezionare pellicole che hanno "murder" nel titolo
-- operatore like prevede due segnaposto
-- %: stringa di qualsiasi lunghezza
-- _: stringa di lunghezza un carattere
select id, official_title
from imdb.movie
where official_title ilike '%murder%';
-- ilike: insensitive like (operatore postgres)

-- soluzione alternativa
select id, official_title, lower(official_title)
from imdb.movie
where lower(official_title) like '%murder%';
-- lower: convert to lowercase


-- selezionare le persone che hanno 'Mark' nel nominativo
select id, given_name
from imdb.person
where given_name like '%Mark%'


-- selezionare le persone che si chiamano 'Mark' di nome (primo o secondo)
select id, given_name
from imdb.person
where given_name like '% Mark %'

-- selezionare le persone che si chiamano 'Mark' di cognome
select id, given_name
from imdb.person
where given_name like '% Mark'

-- selezionare le persone che si chiamano di nome Mark o John
select id, given_name
from imdb.person
where given_name like '%Mark %' or given_name like '%John %' ;


-- selezionare i film con titolo "Murder" seguito da un solo carattere
select id, official_title, lower(official_title)
from imdb.movie
where lower(official_title) like 'murder___';


-- selezionare i film con "Mark John" 
-- Mark John
-- Mark-John
select id, given_name
from imdb.person
where given_name like 'Mark_John';

-- selezionare il titolo delle pellicole prodotte negli Stati Uniti
select movie
from imdb.produced
where country = 'USA';

-- il join tra due tabelle viene costruito sul prodotto cartesiano operando una selezione sul risultato (equijoin dell'algebra relazionale)
select id, official_title
from imdb.produced, imdb.movie
where produced.movie = movie.id and country = 'USA';

-- soluzione alternativa ed equivalente sotto ogni punto di vista
select id, official_title
from imdb.produced inner join imdb.movie on produced.movie = movie.id
where country = 'USA';

-- soluzione con query nidificata (subquery)
-- non la migliore soluzione da un punto di vista prestazionale
select id, official_title
from imdb.movie
where id in (select movie from imdb.produced where country='USA');

-- subquery solo nella where
-- subwquery in clausola from e select NON sono ammesse


-- selezionare i paesi nei quali sono state distribuite le pellicole del 2010 (si restituisca anche il titolo della pellicola - sia quello ufficiale, sia quello usato nella distribuzione dove presente)
select id, official_title, country, title
from imdb.released, imdb.movie
where released.movie = movie.id and year = '2010';

select id, official_title as "titolo originale", country as paese, title as "titolo distribuito"
from imdb.released inner join imdb.movie on released.movie = movie.id 
where year = '2010'
order by official_title;

-- equivalente:
select id, official_title as "titolo originale", country as paese, title as "titolo distribuito"
from imdb.released r inner join imdb.movie as m on r.movie = m.id 
where year = '2010'
order by official_title;

-- selezionare il titolo ufficiale delle pellicole per le quali non è noto il titolo di distribuzione in Italia
select id, official_title
from imdb.released r inner join imdb.movie m on m.id = r.movie 
where r.country = 'ITA' and r.title is null;

select *
from imdb.released r inner join imdb.movie m on m.id = r.movie inner join imdb.country c on r.country = c.iso3
where c.name = 'Italy' and r.title is null;

select *
from imdb.country c inner join imdb.released r on r.country = c.iso3 inner join imdb.movie m on m.id = r.movie
where c.name = 'Italy' and r.title is null;

-- A inner join B inner join C   
-- A inner join C inner join B

-- A inner join B
-- B inner join A


-- selezionare gli attori che hanno recitato nel film Inception
select person, given_name as "nome attore", character as "nome personaggio di inception"
from imdb.movie inner join imdb.crew on movie.id = crew.movie inner join person on person.id = crew.person
where movie.official_title = 'Inception' and p_role = 'actor'
order by given_name;

-- soluzione mediante vista che contiene la troupe delle pellicole
-- costruisco una vista che contiene il nome degli attori e dei corrispondenti personaggi nelle pellicole in cui hanno recitato
create or replace view imdb.movie_cast as (
select id, given_name, character as personaggio, movie
from imdb.person inner join imdb.crew on person.id = crew.person
where p_role = 'actor');

drop view imdb.movie_cast;

-- selezionare gli attori del film inception
select movie_cast.*
from movie inner join movie_cast on movie.id = movie_cast.movie
where official_title = 'Inception';


-- selezionare gli attori che hanno recitato in pellicole del 2010

