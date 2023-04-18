-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti
-- produced(movie,country) released(movie,country)

--soluzione 1
--sottraggo all'insieme dei film l'insieme dei film distribuiti in almeno un paese di produzione
select id 
from imdb.movie
except
select distinct produced.movie
from imdb.produced, imdb.released 
where produced.movie = released.movie and produced.country = released.country;

--soluzione 2
--operatore EXISTS. da utilizzare nella clauso where con argomento una sottoquery. vero se restituisce almeno un risultato, falso se non restituisce alcun risultato
-- un film è nel risultato se non esiste un record di produzione per quel film per il quale esiste un record di distibuzione per quel film nel medesimo paese
select m.id, m.official_title 
from imdb.movie m 
where not exists (
select *
from imdb.produced p 
where m.id = p.movie and exists ( 
select *
from imdb.released r
where p.movie = r.movie and p.country = r.country
));
-- queste query vendono dette query correlate: query nidificate in cui gli alias delle relazioni vengono utiliziate in query diverse

--selezionare i film nei cui cast non ci sono attori nati nei paesi dove il film è stato prodotto
--un film appartine al risultato se non esiste un attore di quel film nato in un paese dove il film è stato prodotto
--un film appartine al risultato se non esiste un attore di quel film per il quale esiste un record di location dove il paese di nascita corrisponde a un paese di produzione del film
select id, official_title
from imdb.movie m
where not exists (
	select *
	from imdb.crew c inner join imdb.produced p on c.movie = p.movie
	where c.movie = m.id and c.p_role = 'actor' and exists ( 
		select *
		from imdb."location" l 
		where c.person = l.person and l.d_role ='B' and l.country = p.country 
	)
);

--titoli dei film che hanno almeno una valutazine superiore alla media delle valutazioni dei film prodotti nel medesimo anno
select distinct id, official_title
from imdb.movie m inner join imdb.rating on m.id = rating.movie
where score > (	
	select avg(score)
	from imdb.rating inner join imdb.movie msub on rating.movie = msub.id
	where m.year = msub.year
);

--altro es
select distinct id, official_title
from imdb.movie m 
where not exists (
	select *
	from imdb.rating r
	where r.movie = m.id and score <= (	
		select avg(score)
		from imdb.rating inner join imdb.movie msub on rating.movie = msub.id
		where m.year = msub.year
));


-- selezionare i film che sono stati distribuiti in tutti i paesi
-- in algebra relazionale: A(R) e B(S) Con S sottoinsieme di attributi proprio di R. Nella divisione A/B kil risultato è definito rugli attributi di R-S
-- pi_{movie,country}(released)/ro_{country<-iso3}(pi_{iso3}(country)) NB bisogna rinominare iso3








