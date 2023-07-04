28/02/23 (slide 01)
- distinzione fra dato e informazione
- esempio di dati non strutturati
- problemi legati all'organizzazione dei dati
- problemi legati alla mancata normalizzazione
- caratteristiche delle basi di dati
- esempi di relazioni uno-a-molti: movie - rating
- esempi di relazioni molti-a-molti: movie - genre


01/03/23 (slide 02)
- diverse tipologie di DBMS
- definizione di DBMS
- caratteristiche dei DBMS
- architettura, utenze, accesso
- introduzione al modello relazionale
- nozioni essenziali del modello relazionale: dominio, vincolo, prodotto cartesiano, grado, cardinalità
- orientamento ai valori nel modello relazionale
- differenza tra schema e istanza di una base di dati
- differenza tra livello intensionale e estensionale di una relazione


07/03/23
- vincoli del modello relazionale
- incompletezza e valori nulli
- vincoli di integrità dei dati
- vincoli di dominio e di ennupla
- vincoli di chiave (superchiave, chiave, chiave primaria) (
- vincoli di integrità referenziale (chiavi esterne)


08/03/23
- introduzione all'algebra relazionale
- operatori booleani (and, or, not)
- operatori (binari) insiemistici (union, intersection, difference)
- operatore (unario) di selezione (select - sigma)
- operatore (unario) di ridenominazione (rho)
- operatore (unario) di proiezione (pi greco)


14/03/23
- prodotto cartesiano di relazioni
- operazioni di join:
-- theta join
-- equijoin
-- join naturale
-- outer join
- operatore di divisione


21/03/23
- regole di ottimizzazione dell'algebra relazionale
- esercizi di algebra relazionale


22/03/23
- introduzione a SQL: insert, delete, update
- esempio di insert con query sql da import csv
- istruzione select
- clausola where di comando select
- operatori booleani


28/03/23
- query SQL: operatori between, in, like, is null
- query SQL: alias di attributi
- query SQL: ordinamento del risultato
- query SQL: operazioni di join
- query SQL: alias di relazione


29/03/23
- query SQL: join esterni
- query SQL: self join
- query SQL: operatori insiemistici (UNION, INTERSECT, EXCEPT)


04/04/2023
- clausola WITH e tabelle temporanee (query CTE)
- query SQL: operatori aggregati
- query SQL: clausola GROUP BY


05/04/2023
- query SQL: clausola HAVING
- valutazione del piano di esecuzione di una query (EXPLAIN)


18/04/2023
- query SQL: query correlate
- query SQL: correlate con aggregazione
- query SQL: operatore EXISTS
- divisione in SQL


19/04/2023
- interrogazioni ricorsive in SQL
- basi di dati attive (asserzioni e trigger)
- viste materializzate
- viste aggiornabili


26/04/2023
- progettazione di una base di dati (concettuale, logica, fisica)
- modelli dei dati (concettuali, logici)
- nozione di astrazione e criteri di astrazione: classificazione, aggregazione, generalizzazione
- progettazione concettuale e modello ER (Entity-Relationship)
- Costrutti del modello ER: entità, associazioni, attributi (atomici, composti)
- Tipologie di relazione: binaria, ternaria, ricorsiva, multipla
- Cardinalità delle associazioni e degli attributi
- Vincoli di cardinalità
- Tipologie di associazione binaria (uno-a-uno, uno-a-molti, molti-a-molti)


02/05/2023
- Costrutti del modello ER:
-- Identificatori interni (semplici e composti)
-- Identificatori esterni (entità deboli)
-- gerarchie di generalizzazione
-- vincoli delle gerarchie: totalità/parzialità, esclusività/sovrapposizione


03/05/2023
- Progettazione logica
-- ristrutturazione dello schema ER
--- analisi dei dati derivati
--- eliminazione delle gerarchie
---- mantenimento della sola entità padre
---- mantenimento delle sole entità figlie
---- mantenimento di tutte le entità
--- eliminazione degli attributi composti
--- eliminazione degli attributi multivalore
--- scelta delle chiavi primarie


09/05/2023
- Progettazione logica
-- traduzione dello schema ER
--- traduzione delle entità
--- traduzione delle associazioni
---- caso 1:1
---- caso 1:N
---- caso N:M
----- analisi del caso serie storiche
---- relazione n-arie
---- relazioni ricorsive


10/05/2023
- nozione di reverse engineering
- esercizio di reverse engineering su db yelp

- esercizi di progettazione concettuale (history)
- esercizi di progettazione logica (history)


16/05/2023
- Normalizzazione e forme normali
- problemi di modellazione
- nozione di dipendenza funzionale
- regole di inferenza
- normalizzazione di relazioni
- forme normali (BCNF, 3NF, 2NF, 1NF)
- Decomposizione delle relazioni
-- conservazione delle dipendenze
-- join non additivo (senza perdita)


23-24/05/2023
- introduzione a progettazione fisica e indici
- il comando SQL CREATE INDEX (non standard)
-- https://www.postgresql.org/docs/current/sql-createindex.html
- occupazione di spazio per la memorizzazione di record
- memoria principale, memoria secondaria, gestione del buffer
- blocchi, pagine
-- fattore di blocco
- strutture primarie
-- accesso sequenziale (non ordinate, ad array, ordinate)
-- accesso calcolato (hash)
-- alberi (indici)
- indici primari
- indici densi
- indici sparsi
- indici secondari
- indici secondari su campi non chiave
- alberi di ricerca
- alberi B e B+


31/05/2023
- sicurezza delle basi di dati: obiettivi e tecniche
- controllo dell'accesso
- politiche di sicurezza e di controllo dell'accesso (need-to-know, maximized sharing)
- granularità dei permessi
- tipologie di controlli
- politiche discrezionali
- attacco del cavallo di troia
- politiche mandatorie
- il System R
- il comando GRANT di SQL
-- https://www.postgresql.org/docs/current/sql-grant.html
- il comando REVOKE di SQL
- il catalogo relazionale di PostgreSQL
-- https://www.postgresql.org/docs/current/information-schema.html
-- tables, columns
-- column_privileges
-- table_privileges
- SYSAUTH e SYSCOLAUTH
- esempi di revoca ricorsiva e grafo delle autorizzazioni
- privilegi su viste


06/06/2023
- nozione di transazione
- concorrenza e problemi legati alla concorrenza
-- lost update
-- dirty read
-- incorrect summary
- proprietà delle transazioni
-- atomicità
-- consistenza
-- isolamento
-- durabilità

- introduzione ai sistemi NoSQL
- Esempi con il sistema NoSQL MongoDB


07/06/2023
- Esercizi di algebra relazionale e SQL con scopus4ds_cs
