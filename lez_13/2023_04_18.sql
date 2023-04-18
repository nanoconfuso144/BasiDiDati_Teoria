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



