-- contenuto di una base di dati:
--- tables (create/alter/drop table)
--- views (create/drop view)
--- domains (create/drop domain)
--- assertions (create/drop assertion)
--- triggers (create/drop trigger)
--- functions/procedures (create/drop function)
--- privileges (grant/revoke privileges)
--- indexes (create/drop index)

-- l'attributo city della tabella department può contenere solo i seguenti valori: Milano, Roma, Firenze, Bologna

create domain filtered_cities as varchar check (value in ('Roma', 'Firenze', 'Bologna', 'Milano'));

create table department (
...
city filtered_cities,
...
);

-- altro esempio di dominio personalizzato: il dominio deve contenere solo interi positivi
create domain positive_numbers as integer check (value > 0);


-- basi di dati attive
-- esempio di asserzione/trigger
-- le asserzioni sono predicati di cui valutare il valore di verità
-- l'asserzione è una regola che coinvolge record diversi di una tabella o record appartenenti a tabelle diverse
-- nella crew di un film deve sempre esistere il regista 

-- trigger: comportamento attivo della base di dati in corrispondenza di un evento e una condizione
-- evento-condizione-azione
-- evento: su inserimento di un record in crew
-- condizione: quando non esiste un record regista rispetto al movie che si sta inserendo
-- azione: bloccare l'inserimento e mandare un messaggio all'utente

create trigger check_director before|after insert or update or delete
on imdb.crew for each row|statement execute procedure list_directors();

insert into imdb.crew(movie, person, p_role) 
values ('1375666', '2378539', 'director');

update imdb.crew set p_role = 'actor' where movie = '1375666' and person = '3523522';


select * from imdb.crew where movie = '1375666'

insert into imdb.crew(movie, person, p_role) 
values ('1375666', '2378539', 'director');

insert into imdb.crew(movie, person, p_role, character) 
values ('1375666', '3582379', 'actor', 'Jim');

delete from imdb.crew where movie = '13756666' and p_role = 'actor';


-- viste materializzate
-- https://www.postgresql.org/docs/current/sql-creatematerializedview.html

-- viste aggiornabili
-- https://www.postgresql.org/docs/current/sql-createview.html

CREATE VIEW imdb.thriller_movies as (
SELECT * from imdb.genre
where genre = 'Thriller') with check option;

insert into imdb.thriller_movies values ('2975590', 'Thriller');
insert into imdb.thriller_movies values ('2975590', 'Comedy');

delete from imdb.genre where movie ='2975590' and genre in ('Thriller', 'Comedy')



