create table imdb.country_area (
country char(3) primary key references imdb.country(iso3),
sqkm double precision
);

insert into imdb.country_area values ('ITA', 301340.0);
insert into imdb.country_area values ('FRA', 643801.0);

-- creaiamo un nuovo paese sottraendo km a francia e italia
begin transaction;	
update imdb.country_area set sqkm = sqkm - 500 where country = 'ITA';
update imdb.country_area set sqkm = sqkm - 500 where country = 'FRA';
insert into country_area values ('FRE', 1000.0);
commit;


-- esempio di rollback esplicito
begin transaction;
...

perform * from imdb.movie where official_title = 'Inception';

if not found then
	rollback;
else
 ...insert into crew(movie)... 
end if;
commit;

-- lost update (U1, U2 utenti)
U1: X:= read(X) + 100
U2: X:= read(X) + 200
U1: write(X) -- +100
U2: write(X) -- +200

-- dirty read
U1: x:= read(X) + 100
U1: write(X)  -- +100
U2: x:= read(X) + 200
U2: write(X)  -- +200
U1: error/abort

-- incorrect summary
U2: sum := 0
U1: x := read(X) + 100
U1: write(X)
U2: sum := sum + read(X)
U2: sum := sum + read(Y)
U1: y := read(Y) + 200
U1: write(Y)
