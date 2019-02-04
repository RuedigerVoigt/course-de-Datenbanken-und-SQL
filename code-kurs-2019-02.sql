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
    -- ASC = ASCEBDING (aufsteigend)
    -- DESC = DESCENDING (absteigend)
    -- beliebig viele Sortierkriterien durch Komma getrennt
    nachname ASC,
    vorname DESC
LIMIT 2; -- wir begrenzen die Ausgabe auf zwei Zeilen





-- ein View in Ihrer persönlichen Datenbank


USE tn_x; -- Kontext herstellen. Annahme: ihre Datenbank heiißt tn_x

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
ORDER BY -- erst mit HWERE einschränken, dann sortieren
    born ASC; -- kleinstes Geburtsdatum bedeutet älteste Person

/* *********************************************************************** 
*  DIENSTAG
*************************************************************************/


/* *********************************************************************** 
*  MITTWOCH
*************************************************************************/


/* *********************************************************************** 
*  DONNERSTAG
*************************************************************************/

/* *********************************************************************** 
*  FREITAG
*************************************************************************/
