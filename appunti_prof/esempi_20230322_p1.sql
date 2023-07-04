-- insert command
-- esempio insert movie(id, official_title, budget, year, length, plot)
insert into <tablename> values (<list of values>);

insert into imdb.movie values 
('933839', 'my movie', 30000, '2023', 124, 'The movie is about...');

-- insert con valori malposti sugli attributi
insert into imdb.movie values 
('948585', 'my second movie', '2023', 124);

-- versione  corretta
insert into imdb.movie values 
('837583', 'my third movie', null, '2023', 124, null);

insert into imdb.movie(id, official_title, year, length) values 
('948585', 'my second movie', '2023', 124);

-- inserimento valore extra su year. cosa succede?
insert into imdb.movie(id, official_title, year, length) values 
('384839', 'my fourth movie', '20235', 124);

-- è possibile modificare l'ordine degli attributi
insert into imdb.movie(id, year, length, official_title) values 
('948585', '2023', 124, 'my second movie');

-- skip record in csv. cosa succede se un record è vuoto nel csv?


-- insert di un set di record da file
-- copy command
create table imdb.movie_temp (
id varchar(10) primary KEY,
title varchar(200),
year char(4),
length integer
);

copy imdb.movie_temp(id, title, year, length) 
from '/Users/jep/Downloads/movies_to_add.csv'
(format csv, header false, delimiter ',');

-- trasferimento record da movie_temp a movie
insert into imdb.movie(id, official_title, year, length)
(select id, title, year, length from imdb.movie_temp);

insert into imdb.movie(id, official_title, year)
(select id, title, year from imdb.movie_temp);

insert into imdb.movie(id, official_title, year, length)
(select id, title, year, length from imdb.movie_temp where year = '2004');

insert into imdb.movie(id, official_title, year, length)
(select * from imdb.movie_temp where year = '2004');

-- prelevo il record che ha generato errore nell'inserimento (chiave duplicata)
select * from imdb.movie_temp where id = '0361430';
select * from imdb.movie where id = '0361430';


-- cancellare dati da una tabella
delete from <table name> [ where <condition> ]

delete from imdb.movie_temp where length = 114;
delete from imdb.movie_temp where length = 1140;
delete from imdb.movie_temp;
delete from imdb.movie_temp where id = '0361430';


-- modifica dei dati di una tabella
-- comando update
update <table_name> set <operazione_da_eseguire> [ where <condizione> ];

update imdb.movie_temp set year = '1980' where id = '0425253';

update imdb.movie_temp set length = length + 1;

update imdb.movie_temp set year = null where id = '0380510';


-- query semplici in sql
select id, title, year, length 
from imdb.movie_temp 
where year = '2004';

select *
from imdb.movie_temp 
where year = '2004';

select *
from imdb.movie_temp;
