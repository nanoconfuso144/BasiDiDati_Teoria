-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti
-- produced
-- movie   |  country
--   001   |    ITA
--   001   |    USA
--   002   |    USA
--   003   |    SPA
--   003   |    ITA


-- released
-- movie   |  country 
--  001	 |    ITA
--  001    |    FRA
--  002    |    GBR
--  002    |    ITA
--  002    |    SPA
--  003	 |    USA
--  003    |    FRA
--  003    |    GBR


-- A: trovo le pellicole che sono prodotte in almeno un paese dove sono distribuite
-- una pellicola è nel risultato se almeno un paese di produzione è anche nella distribuzione
select distinct produced.movie
from imdb.produced, imdb.released
where produced.movie = released.movie and produced.country = released.country

-- dall'insieme dei film sottraggo l'insieme A
explain (format json) select id 
from imdb.movie
except
select distinct produced.movie
from imdb.produced, imdb.released
where produced.movie = released.movie and produced.country = released.country;

-- risultato: 171 record

select * from imdb.produced where movie = '4457582';
select * from imdb.released where movie = '4457582';

-- exists
-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti
-- un film è nel risultato della query se non esiste un record di produzione di quel film per il quale esiste un record di distribuzione per quel film nel medesimo paese
-- query correlata
explain (format json) select m.id, m.official_title
from imdb.movie m
where not exists (
select *
from imdb.produced p
where m.id = p.movie and exists (
select *
from imdb.released r 
where p.movie = r.movie and p.country = r.country));

-- verifico che le due soluzioni abbiano lo stesso risultato
with except_result as (
select id 
from imdb.movie
except
select distinct produced.movie
from imdb.produced, imdb.released
where produced.movie = released.movie and produced.country = released.country),
exists_result as (
select m.id, m.official_title
from imdb.movie m
where not exists (
select *
from imdb.produced p
where m.id = p.movie and exists (
select *
from imdb.released r 
where p.movie = r.movie and p.country = r.country)))
select id
from except_result
intersect
select id
from exists_result;

-- movie(id)
--  001
--  002
--  003

-- produced
-- movie   |  country
--   001   |    ITA
--   001   |    USA
--   002   |    USA
--   003   |    SPA
--   003   |    ITA


-- released
-- movie   |  country 
--  001	 |    ITA
--  001    |    FRA
--  002    |    GBR
--  002    |    ITA
--  002    |    SPA
--  003	 |    USA
--  003    |    FRA
--  003    |    GBR


-- selezionare i film nel cui cast non figurano attori nati in paesi dove il film è stato prodotto
-- un film appartiene al risultato se non esiste un attore di quel film nato in un paese dove il film è stato prodotto
-- un film appartiene al risultato se non esiste un attore di quel film per il quale esiste un record di location dove il paese di nascita corrisponde a un paese di produzione del film
select id, official_title
from imdb.movie m
where not exists (
select *
from imdb.crew c inner join imdb.produced p on c.movie = p.movie
where c.movie = m.id and c.p_role = 'actor' and exists (
select *
from imdb.location l
where c.person = l.person and l.d_role = 'B' and l.country = p.country
));

select * from imdb.produced where movie ='0166085';

select distinct country
from imdb.location inner join imdb.crew on crew.person = location.person
where movie ='0166085' and p_role = 'actor' and d_role = 'B';


-- selezionare il titolo dei film che hanno almeno una valutazione superiore alla media delle valutazioni dei film prodotti nel medesimo anno
select distinct id, official_title
from imdb.movie m inner join imdb.rating on m.id = rating.movie
where score >
(select avg(score)
from imdb.rating inner join imdb.movie msub on rating.movie = msub.id
where m.year = msub.year
);

-- 485 record nel risultato

-- selezionare il titolo dei film che hanno tutte le valutazioni superiori alla media delle valutazioni dei film prodotti nel medesimo anno
select distinct id, official_title
from imdb.movie m 
where not exists (
select *
from imdb.rating r
where r.movie = m.id and r.score <=
(select avg(score)
from imdb.rating inner join imdb.movie msub on rating.movie = msub.id
where m.year = msub.year
));

-- 585 record nel risultato

-- selezionare i film con cast più numeroso della media dei film del medesimo genere


-- selezionare i film che sono stati distribuiti in tutti i paesi
-- un film m è nel risultato se non esiste un paese c per il quale non esiste la distribuzione di m in c

     ( \pi_{movie,country} (released) ) / ( \rho_{country <- iso3} ( \pi_{iso3} (country) ) )

nella divisione la relazione A è definita su un insieme di attributi R che sono un sottoinsieme proprio degli 
attributi S su cui è definita la relazione B
Il risultato delle divisione è definito sugli attributi di R-S
A(R)
B(S)

select id, official_title
from imdb.movie m
where not exists (
select *
from imdb.country c
where not exists (
select *
from imdb.released r
where m.id = r.movie and c.iso3 = r.country
));

-- selezionare le persone che hanno recitato in tutti i film di genere Crime
-- data la persona A, non esiste un film di genere Crime in cui A non abbia recitato
-- se A ha recitato in tutti i movie Crime, non deve esistere un movie Crime per il quale non esiste la partecipazione di A

A / B

B = \pi_{movie} ( \sigma_{genre = 'Crime'} (GENRE)) 
A =  \pi_{person,movie} ( \sigma_{p_role = 'actor'} (CREW))

select p.id, p.given_name
from imdb.person p
where not exists (
select * 
from imdb.genre g
where g.genre = 'Crime' and not exists (
select *
from imdb.crew c
where c.p_role = 'actor' and c.movie = g.movie and c.person = p.id
));
