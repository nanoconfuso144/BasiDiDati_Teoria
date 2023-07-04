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