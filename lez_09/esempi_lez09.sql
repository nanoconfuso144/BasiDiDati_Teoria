
select id, official_title, country, title 
from imdb.released, imdb.movie
where released.movie = movie.id and year = '2010';
-- equivalente
select id, official_title, country, title 
from imdb.released inner join imdb.movie on released.movie = movie.id
where year = '2010';

--cambio il nome delle colonne nel risultato della query
select id, official_title as "titolo originale", country, title as "titolo distribuito"
from imdb.released inner join imdb.movie on released.movie = movie.id
where year = '2010'
order by official_title;

--selezionare il titolo ufficiale delle pellicole per le quali non è noto il titolo di distribuzione in Italia
select id, official_title, title, country
from imdb.released r inner join imdb.movie m on m.id = r.movie
where r.country = 'ITA' and r.title is null;

--gli attori che hanno recitato nel film inseption
select person, given_name as "nome attore", character as "nome personaggio in Inseption"
from imdb.movie inner join imdb.crew on movie.id = crew.movie inner join imdb.person 
on person.id = crew.person
where movie.official_title = 'Inception' and p_role = 'actor'
order by given_name;

--creo una vista
create view imdb.movie_cast as (
select id, given_name, character, movie
from imdb.person inner join imdb.crew on person.id = crew.person
where p_role = 'actor'
);

--selezionare gli attori di inception
select movie_cast.*
from imdb.movie inner join imdb.movie_cast on movie.id = movie_cast.movie
where official_title = 'Inception';



