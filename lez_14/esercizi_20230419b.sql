-- trovare tutti i film simili a inception
select sim.*, m2.official_title
from imdb.movie inner join imdb.sim on movie.id = sim.movie1 inner join imdb.movie m2 on sim.movie2 = m2.id
where movie.official_title = 'Inception';

-- trovare tutti i film simili a inception a qualsiasi livello di distanza
-- trovare tutti i film simili a inception al massimo a distanza 3

-- restituire i primi 100 numeri interi
with recursive get_number(n) as (
select 1
union 
select n+1
from get_number
where n < 100)
select n from get_number;

-- assumiamo che i generi cinematografici siano organizzati gerarchicamente:
-- Thriller
--- Noir
---- Poliziesco
----- Spionaggio
----- Romanzo rosa

-- struttura della tabella genre_taxonomy 
genre_taxonomy(genre_name, genre_parent)

create table imdb.genre_taxonomy (
genre_name varchar primary key,
genre_parent varchar 
);

alter table imdb.genre_taxonomy add constraint "fk_genre_taxonomy" foreign key (genre_parent) references imdb.genre_taxonomy(genre_name);

insert into imdb.genre_taxonomy(genre_name) values ('Thriller');
insert into imdb.genre_taxonomy(genre_name, genre_parent) values ('Noir', 'Thriller');
insert into imdb.genre_taxonomy(genre_name, genre_parent) values ('Poliziesco','Noir');
insert into imdb.genre_taxonomy(genre_name, genre_parent) values ('Spionaggio', 'Poliziesco');
insert into imdb.genre_taxonomy(genre_name, genre_parent) values ('Romanzo rosa', 'Poliziesco');

Thriller  |  NULL
Noir 	  |  Thriller
Poliziesco|  Noir
Spionaggio|  Poliziesco
Romanzo rosa | Poliziesco

-- trovare i generi in cui "Poliziesco" è contenuto
-- risultato:
-- Noir (1)
-- Thriller (2)

-- trovare i generi in cui "Spionaggio" è contenuto
-- risultato:
-- Spionaggio - Poliziesco - 1
-- Spionaggio - Noir - 2
-- Spionaggio - Thriller - 3
with recursive get_parent(f_genre, t_genre, distance) as (
select genre_name, genre_parent, 1
from imdb.genre_taxonomy
union
select gp.f_genre, gt.genre_parent, distance + 1
from get_parent gp, genre_taxonomy gt 
where gp.t_genre = gt.genre_name
)
select *
from get_parent
where f_genre = 'Spionaggio' and t_genre is not null;

-- trovare tutti i film simili a inception a qualsiasi livello di distanza
-- trovare i film simili a inception a distanza massima 3
explain (analyze true, format json) with recursive search_sim(f_movie, t_movie, distance) as (
select movie1, movie2, 1
from imdb.sim inner join imdb.movie on movie.id = sim.movie1
where official_title = 'Inception'
union
select ss.f_movie, s.movie2, distance + 1
from search_sim ss, imdb.sim s
where ss.t_movie = s.movie1 and distance < 3
)
select f_movie, 'Inception' as f_official_title, t_movie, official_title as t_official_title, distance
from search_sim inner join movie on t_movie = movie.id;





select id from imdb.movie where official_title = 'Inception'

