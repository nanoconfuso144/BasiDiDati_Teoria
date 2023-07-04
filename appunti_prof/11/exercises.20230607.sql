-- esercizio A: derivare lo schema ER del db scopus4ds (reverse engineering)

-- esercizio B: svolgere i seguenti esercizi di algebra relazionale e SQL

-- conta il numero di pubblicazioni nel db
select count(*) from publications.publication;

-- quali sono i pubtype utilizzati nelle pubblicazion
select distinct pubtype from publications.publication;

-- trovare le keyword che non sono mai usate su pubblicazioni di tipo article
-- faccio la differenza fra tutte le keyword e le keyword usate su pubblicazioni di tipo article

-- EXPLAIN ANALYZE
SELECT distinct keyword
FROM publications.keyword
EXCEPT
SELECT distinct keyword
FROM publications.keyword INNER JOIN publications.publication ON pubid = id
WHERE pubtype = 'article';

-- questa soluzione sembra più efficiente
-- EXPLAIN ANALYZE
SELECT distinct k.keyword
FROM publications.keyword k
WHERE not exists (
select *
FROM publications.keyword INNER JOIN publications.publication ON pubid = id
WHERE pubtype = 'article' and keyword.keyword = k.keyword
);

-- versione con left join?


-- trovare le keyword usate in tutte le pubblicazioni della rivista 'computer communications'
-- una keyword k1 è nel risultato se non esiste una pubblicazione p di 'computer communications' per la quale non esiste l'associazione di k1 con p
select k1.keyword
from publications.keyword k1
where not exists (
select *
from publications.publication p
where pubname = 'computer communications' and not exists (
select *
from publications.keyword k2
where k2.keyword = k1.keyword and k2.pubid = p.id));

-- trovare le pubblicazioni che hanno sia 'social networks' sia 'community detection' come keyword


-- trovare le pubblicazioni che hanno almeno una keyword in comune


-- trovare gli autori che partecipano a una pubblicazione con almeno due affiliazioni diverse
select distinct pa1.authid
from publications.pub_author pa1 inner join publications.pub_author pa2 on pa1.pubid = pa2.pubid and pa1.afid <> pa2.afid and pa1.authid = pa2.authid;

-- trovare le pubblicazioni con citazioni superiori alla media considerando le pubblicazioni della rivista 'information and computer security'
with avg_citations as (
select avg(citedby) as avg_c
from publications.publication 
where pubname = 'information and computer security')
select id, citedby
from publications.publication, avg_citations
where citedby > avg_c and pubname = 'information and computer security';

-- trovare le pubblicazioni con il maggior numero di keyword associate
with count_keywords as (
select pubid, count(keyword) as count_k 
from publications.keyword
group by pubid
), max_count as (
select max(count_k) as max_k
from count_keywords)
select pubid, count_k 
from publications.publication inner join count_keywords on pubid = id, max_count
where count_k = max_k;

-- trovare tutte le expertise da cui discende conceptual design
with recursive get_parent(f, p, d) as (
select field, parent_field, 1
from publications.expertise
union
select gp.f, e.parent_field, d + 1
from get_parent gp, publications.expertise e 
where gp.p = e.field
)
select p, d
from get_parent
where f = 'conceptual design' and p is not null;


-- ulteriori esercizi 
-- trovare le pubblicazioni X con citazioni superiori alla media considerando le pubblicazioni della rivista di X
with journal_citations as (
select pubname, avg(citedby) as avg_citations
from publications.publication
group by pubname)
select id, title, publication.pubname, citedby, avg_citations
from publications.publication inner join journal_citations on publication.pubname = journal_citations.pubname
where citedby > avg_citations;

-- inefficiente
select id, title, pubname, citedby
from publications.publication p
where citedby > (
	select avg(citedby)
	from publications.publication
	where pubname = p.pubname);

-- trovare i co-autori di montanelli stefano (autori di pubblicazioni in cui montanelli stefano è autore)
select distinct a2.*
from publications.author a1 inner join publications.pub_author pa1 on a1.authid = pa1.authid inner join publications.pub_author pa2 on pa1.pubid = pa2.pubid inner join publications.author a2 on pa2.authid = a2.authid\
where a1.authname = 'montanelli s.' and a2.given_name <> 'montanelli s.';

-- trovare le keyword usate solo sulla rivista 'information and computer security'
select distinct keyword
from publications.keyword inner join publications.publication on pubid = id
where pubname = 'information and computer security'
except
select distinct keyword
from publications.keyword inner join publications.publication on pubid = id
where pubname <> 'information and computer security';

-- Trovare la keyword usata il maggior numero di volte 
with keyword_count as (
select keyword, count(distinct pubid) as count_p
from publications.keyword
group by keyword), max_keyword as (
select max(count_p) as max_p
from keyword_count)
select keyword, max_p
from keyword_count inner join max_keyword on count_p = max_p;

-- trovare gli autori che non pubblicano con persone appartenenti alla medesima affiliazione
select authid
from publications.pub_author pa1
where not exists (
select *
from publications.pub_author pa2
where pa1.pubid = pa2.pubid and pa1.afid = pa2.afid and pa1.authid = pa2.authid);

