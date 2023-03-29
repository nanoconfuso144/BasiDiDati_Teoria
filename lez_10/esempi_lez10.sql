--cosa è una view? è una query che viene memorizzata nella memoria del database con un'etichetta

--posso creare o modificare una view con il seguente comando.
--posso modificare una view solo se non ho modificato uno schema, ma, magari, solo aggiornato i record
create or replace view imdb.movie_cast as {
select id given_name, character as personaggio, movie
from imdb.person inner join imdb.crew on person.id = crew.person
where p_role = 'actor'
};
-- per eliminare una view
drop view imdb.movie_cast

-- INIZIO ESERCIZI DEL 29/03/2023

--es1
-- selezionare le persone che sono decedute in un paese diverso da quello di nascita.
-- tabelle interessate: location, dove il valore d_role indica se il record indica il luogo di nascita (B) o di morte (D)

select lbirth.person as "presone decedute lontano da casa", lbirth.country as "paese di nascita", ldeath.country as "paese di decesso"
from imdb.location lbirth, imdb.location ldeath
where lbirth.d_role = 'B' and ldeath.d_role = 'D' and lbirth.person = ldeath.person and lbirth.country <> ldeath.country;

--equivalentemente, ma più pulito dal punto di vista concettuale
select lbirth.person as "presone decedute lontano da casa", lbirth.country as "paese di nascita", ldeath.country as "paese di decesso"
from imdb.location lbirth inner join imdb.location ldeath on lbirth.person = ldeath.person and lbirth.country <> ldeath.country
where lbirth.d_role = 'B' and ldeath.d_role = 'D';

--se volessi mostrare il nome?
-- mi serve la tabella person

select lbirth.person as "presone decedute lontano da casa", given_name ,lbirth.country as "paese di nascita", ldeath.country as "paese di decesso"
from imdb.location lbirth inner join imdb.location ldeath on lbirth.person = 
ldeath.person and lbirth.country <> ldeath.country inner join imdb.person on imdb.person.id = lbirth.person 
where lbirth.d_role = 'B' and ldeath.d_role = 'D';

--es2
--selezionare i film che non hanno materiali associati
--uso outer join
--left join perchè mi interessano le tuple spurie (che non hanno corrispondenza) di movie.

select movie.id, official_title
from imdb.movie left join imdb.material on movie.id = material.movie
where material.movie is null;

--soluzione con sottrazione: operatore except
--prima query: (A) la totalità dei film
--seconda query: (B) i movie con materiali associati
-- soluzione A-B
-- NB per essere sottratte le due query devono essere compatibili: devono avere lo stesso numero di colonne (grado) e compatibili con l'unione

select id 
from imdb.movie
except
select distinct movie
from imdb.material;

-- se volessi anche il titolo?

select id, official_title 
from imdb.movie
except
select distinct movie.id, official_title 
from imdb.movie inner join imdb.material on movie.id = material.movie; 























