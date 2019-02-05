/* *********************************************************************** 
*  MONTAG
*************************************************************************/

-- ein etwas komplexeres SELECT-Statement:

SELECT
    -- wir fassen zwei Columns und ein Leerzeichen zusammen
    CONCAT(vorname, ' ', nachname) AS FullName
FROM
    kurs_2019feb_shared.`personen` -- die Datenbank und Tabelle, welche wir abfragen
    -- Trenner ist ein Punkt!
WHERE
    geschlecht = 1 -- die Bedingung, welche die Datensätze erfüllen müssen
ORDER BY
    -- sortieren nach zwei Kriterien
    -- ASC = ASCENDING (aufsteigend)
    -- DESC = DESCENDING (absteigend)
    -- beliebig viele Sortierkriterien durch Komma (!) getrennt
    -- AND funktioniert hier nicht!
    nachname ASC,
    vorname DESC
LIMIT 2; -- wir begrenzen die Ausgabe auf zwei Zeilen





-- ein View in Ihrer persönlichen Datenbank


USE tn_x; -- Kontext herstellen. Annahme: ihre Datenbank heißt tn_x

CREATE VIEW alteSchauspieler -- wir benennen den View
AS -- nach dem Schlüsselwort AS folgt die Definition
SELECT 
    CONCAT(FirstName, ' ' , LastName) AS Name
    , born AS Geburtsdatum
FROM movies.actors -- voller Pfad inklusive Datenbank-Name!
WHERE
    died IS NULL -- kein Todesdatum: lebt noch
    AND -- Verknüpfung: beide Bedingungen müssen erfüllt sein
    sex = 'm' -- wir filtern über das Geschlecht
ORDER BY -- erst mit WHERE einschränken, dann sortieren
    born ASC; -- kleinstes Geburtsdatum bedeutet älteste Person

/* *********************************************************************** 
*  DIENSTAG
*************************************************************************/

-- Aggregatfunktion

SELECT AVG(annualIncome) FROM kurs_2019feb_shared.personen;
SELECT MAX(annualIncome) FROM kurs_2019feb_shared.personen;
SELECT MIN(annualIncome) FROM kurs_2019feb_shared.personen;



-- GROUP BY
-- am Beispiel Durchschnittseinkommen abhängig vom Geschlecht
SELECT
-- hier nur Felder nach denen gruppiert wird und/oder Aggregatfunktionen
-- andere Felder sind eine wilkürliche Auswahl
    geschlecht,
    AVG(annualIncome)
FROM
    -- datenbank punkt tabelle
    kurs_2019feb_shared.personen
GROUP BY
    -- die Column nach der sortiert wird
    geschlecht;

-- Dieses GROUP BY ersetzt hier zwei Abfragen:
SELECT geschlecht, AVG(annualIncome) FROM kurs_2019feb_shared.personen WHERE geschlecht = 0;
SELECT geschlecht, AVG(annualIncome) FROM kurs_2019feb_shared.personen WHERE geschlecht = 1;
-- gäbe es mehr Kategorien im Datensatz, würde die Berechnung für Alle durchgeführt



-- GROUP BY mit mehreren Kriterien

SELECT
    geschlecht, -- nicht random, weil für jeden Eintrag in der Gruppe gleich
    country,
    AVG(annualIncome) AS 'Durchschnittseinkommen'
FROM
    kurs_2019feb_shared.personen
GROUP BY
-- beliebig viele Gruppen
-- durch Komma getrennt, also *nicht* mit AND verbinden
    geschlecht,
    country

/*
Ergebnis könnte sein:

geschlecht country Durchschnittseinkommen
0   DE  (berechnetes Durchschnittseinkommen für Frauen in Deutschland)
0   US  (berechnetes Durchschnittseinkommen für Frauen in den USA)
1   DE  (berechnetes Durchschnittseinkommen für Männer in Deutschland)
1   US  (berechnetes Durchschnittseinkommen für Männer in den USA)
*/


-- LEFT JOIN


-- Aufgabe: finden Sie die 10 am besten bewerteten Filme in der Datenbank
SELECT
    -- hier können wir Felder aus allen Tabellen anzeigen, die
    -- wir mittels JOIN verbunden haben
    f.titleEn AS Titel,
    f.year AS Jahr,
    f.rottenTomatoesAvg AS Rating,
    g.genreName AS 'primäres Genre'
FROM
    -- wir vergeben das Kürzel f um nicht jedes Mal movies.film tippen zu müssen
    movies.film AS f
LEFT JOIN
    movies.genre AS g
ON
    g.id = f.primaryGenre
ORDER BY
    f.rottenTomatoesAvg DESC -- das höchste Rating zuerst
LIMIT 10 -- nach 10 Filmen schneiden wir die Ausgabe ab, denn wir wollten die besten 10







/* Mehrere Abfragen kombinieren

Aufgabenstellung:
- verbinden Sie die Tabelle airports mit der Tabelle country
- geben Sie den Namen des Flughafen, den IATA-Code in Klammern und
  das Land in ausgeschriebener Form aus
- filtern Sie auf aktive Flughäfen in Deutschland

*/



-- erster Schritt (einfach nur der JOIN mit ALLEN Feldern beider Tabellen
-- in der richtigen Zuordnung nebeneinander):

SELECT
   *
FROM
    geo.airports AS a
LEFT JOIN
    geo.country AS c
ON
    c.`ISO_3166-1-alpha-2_code` = a.country





-- erfüllte Aufgabe:


SELECT
    -- Die Klammern müssen mittels CONCAT() um den IATA-Code gesetzt werden.
    -- Wir wollen Sie nicht im Spaltennamen, sondern im Ergebnis.
    CONCAT(a.name, ' (', a.iataCode, ')') AS 'Flughafen',
    -- Mit dem Kürzel angeben aus welcher Tabelle die Column genutzt werden soll.
    -- Unverzichtbar falls ein Column-Name in meheren Tabellen verwendet wird!
    c.german_short AS 'Land' -- sinnvolles Umbenennen der Spalten
FROM
    geo.airports AS a
LEFT JOIN -- Angabe welche Tabelle "gejoined" werden soll
    geo.country AS c
ON -- Das Kriterium mit welchem die Tabellen zusammengefügt werden:
    c.`ISO_3166-1-alpha-2_code` = a.country
    -- ACHTUNG: das Feld ISO.. muss in Backticks (nicht AFZ!), 
    -- weil es ein Feldname mit Sonderzeichen ist!
    -- Die Tabelle country hat als Primärschlüssel den ISO-Code.
    -- Logik: das Feld in der Fremdtabelle soll welchem Feld in der 
    -- Tabelle entsprechen, die wir mit SELECT zuerst abfragen?
WHERE
    a.country = 'DE' AND active = 1
    -- zwei Filterbedingungen, die beide erfüllt sein müssen.
    -- kein BER in der Ausgabe
ORDER BY
    c.german_short
    -- jetzt nachdem klar ist, was angezeigt wird, können wir sortieren
    
/* AUSGABE:
Flughafen Land
Flughafen Bremen (BRE) Deutschland
Flughafen Dortmund (DTM) Deutschland
Flughafen Frankfurt am Main (FRA) Deutschland
Flughafen Hamburg (HAM) Deutschland
Flughafen Leipzig/Halle (LEJ) Deutschland
Flughafen München (MUC) Deutschland

[...]

*/





/* *********************************************************************** 
*  MITTWOCH
*************************************************************************/

-- VERTIEFUNG AGGREGATFUNKTIONEN

-- Aufgabe: Suchen Sie die Person / die Personen mit dem höchsten Jahreseinkommen
-- Folgendes funktioniert NICHT:
-- SELECT * FROM kurs_2019feb_shared.personen WHERE annualIncome = MAX(annualIncome);
-- ABER mittels Sub-Select:
SELECT * 
FROM kurs_2019feb_shared.personen 
WHERE annualIncome = (SELECT MAX(annualIncome) FROM kurs_2019feb_shared.personen);
-- beachten: innerhalb der Klammer kein Semikolon!



/* *********************************************************************** 
*  DONNERSTAG
*************************************************************************/

/* *********************************************************************** 
*  FREITAG
*************************************************************************/
