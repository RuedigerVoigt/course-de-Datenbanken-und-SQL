-- MONTAG 22.07.2019

/* 
Zunächst hatten wir eine Beispielstabelle "Personen" angelegt und diese dann mit
SELECT abgefragt:
- Statt alle Spalten mit * anzuzeigen, wird die Anzeige auf die zwei Spalten
  vorname und nachname eingeschränkt.
- Die WHERE-Bedingung filtert die Zeilen. Hier sind zwei Bedingungen mit AND
  verknüpft: die Anrede muss "Frau" lauten (wegen der Einstellungen der Datenbank
  spielt hier Groß- / Kleinschreibung keine Rolle) und die ID des Eintrags muss 
  größer als 2 sein.
- ORDER BY sortiert: zunächst aufsteigend nach Nachname und innerhalb der Personen 
  mit gleichem Nachnamen noch nach Vorname. ASC bedeutet aufsteigend ("ascending"), 
  DESC wäre absteigend.
*/

SELECT 
    vorname, 
    nachname 
FROM `personen` 
WHERE anrede = 'frau' AND id > 2
ORDER BY nachname ASC, vorname ASC;

/*
Ihre Aufgabe war aus der vorhandenen Tabelle airports in der Datenbank geo alle
Flughäfen in Deutschland sortiert nach IATA-Code auszugeben
*/

SELECT
    `iataCode`,
    `name`
FROM
    `airports`
WHERE
    `country` = 'DE'
ORDER BY
    `iataCode` ASC;
    
    
-- DIENSTAG 23.07.2019

