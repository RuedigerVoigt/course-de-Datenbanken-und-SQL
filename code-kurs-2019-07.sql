-- ------------------------------------------------------------
-- MONTAG 22.07.2019
-- ------------------------------------------------------------

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
 
-- ------------------------------------------------------------
-- DIENSTAG 23.07.2019
-- ------------------------------------------------------------

-- Mit AS können Sie Spaltentitel in der Anzeige (!) umbenennen.
-- Sie ändern damit nicht die Datenbankstruktur.

SELECT 
  prename AS Vorname, 
  lastname AS Nachname 
FROM personen;

-- WICHTIG: Neue Feldnamen dürfen nicht wie SQL-Befehle heißen
-- Folgendes erzeugt einen Syntaxfehler, weil ALTER ein Teil
-- von Befehlen, wie zum Beispiel ALTER TABLE ist.
SELECT
  age AS Alter 
FROM personen;

-- Rechnen in der Ausgabe
-- auch hier keine Änderung auf dem System

SELECT (einkommen * 2) AS doppeltesEinkommen FROM `personen`;

-- EINFÜGEN MIT INSERT
-- Bei Feldern mit autoincrement fügen Sie nichts ein!
-- Felder mit Default-Werten (zum Beispiel TIMESTAMP) können 
-- Sie auslassen.

INSERT INTO `personen` 
(`anrede`, `nachname`) -- welche Felder möchten Sie befüllen 
VALUES 
-- ACHTUNG: die gleiche Reihenfolge wie die Angabe welche Felder befüllt werden
('Frau','Müller'), -- Jeder Datensatz in Klammern
-- Kalmmern mit Komma getrennt um mehrere gleichzeitig einzufügen
('Herr','Schmitz');



-- FELDER AKTUALISIEREN MIT UPDATE

UPDATE `personen` 
SET `anrede`= 'Frau', vorname = 'Karla' 
WHERE id = 1;

-- LÖSCHEN MIT DELETE
-- Hier machen eindeutige Identifizierungsmerkmale Sinn um 
-- gezielt löschen zu können.

DELETE FROM `personen` WHERE `id`= 4;

-- DER LIKE-OPERATOR
-- % ist dabei Platzhalter für beliebige Zeichen
-- Lui% matcht dann zum Beispiel Luisa und Luise.

SELECT * FROM `personen` WHERE vorname LIKE 'Lui%';


-- AGGREGATFUNKTIONEN
-- Standard sind: MIN(), MAX(), AVG(), COUNT()

SELECT COUNT(*) FROM `airports`; -- die Zahl der Zeilen in airports

-- Zahl der Flughäfen in Deutschland 
-- oder Großbritannien:
SELECT COUNT(*) FROM `airports` 
WHERE country = 'DE' OR country = 'GB';

-- Aufaddieren der Flächen
SELECT 
  SUM(area_sqkm) 
FROM `country_subdivisions`;

-- Prüfen auf NULL
-- Weil NULL eine Sonderfunktion hat, funktioniert der 
-- Vergleich mit = oder != NICHT

-- IS NULL um NULL-Werte zu finden:
SELECT * FROM meineTabelle WHERE irgendeineSpalte IS NULL;
-- IS NOT NULL für das Gegenteil:
SELECT * FROM meineTabelle WHERE irgendeineSpalte IS NOT NULL;

-- ---------------------------------------------
-- LEFT JOIN
-- Alle Zeilen aus der "linken" Tabelle ergänzt um die
-- passenden Zeilen aus der anderen Tabelle.
-- Mehr:
-- https://www.w3schools.com/sql/sql_ref_left_join.asp
-- ---------------------------------------------

SELECT
-- es könnten Spaltennamen in mehreren Tabellen auftauchen. Deshalb 
-- DB-Kürzel notwendig.
  u.name,
  c.japanese_short -- hier die Übersetzung ausgewählt
FROM `universities` AS u -- Kürzel vergeben um nicht immer auschreiben zu müssen
LEFT JOIN cities AS c 
  ON u.city = c.id 
WHERE c.german_short IS NOT NULL AND u.country = 'DE';

-- ------------------------------------------------------------
-- MITTWOCH 24.07.2019
-- ------------------------------------------------------------

-- Alle *unterschiedlichen* Werte einer Spalte:
SELECT DISTINCT columName FROM tableName;

-- FALLE: folgendes Statement gibt nicht die Spalten A und B
--        zurück, sondern den Inhalt von A mit dem 
--        Spaltentitel B.

SELECT A B FROM irgendeineTabelle;

-- Grund: das ist aufgrund des fehlenden Komma zwischen A und B
--        eine Kurzschreibweise für:
SELECT A AS B FROM irgendeineTabelle;

-- Filme, absteigend sortiert nach Rating.
-- Über ein LEFT JOIN die Bezeichnung
-- für das Genre eingebunden.

-- Aufgabe: Finden Sie die 10 besten Filme in der Datenbank
CREATE VIEW top10 AS -- AS ist hier nicht Umbennenung.
-- Alles nach dem AS ist die Definition des View-Inhalts
SELECT
    f.titleEn AS Titel,
    g.genreName AS Genre,
    f.year AS Jahr,
    f.myRating * 2 AS `Eigenes Rating`, -- rechnen innerhalb der Anzeige
    f.rottenTomatoesAvg AS 'Rotten Tomatoe Bewertung'
FROM
    movies.film AS f
LEFT JOIN movies.genre AS g
    ON f.primaryGenre = g.id
ORDER BY f.myRating DESC 
LIMIT 10; -- Beschränkung auf die ersten 10 Ergebnisse
-- Hinweis: bei Microsoft SQL Server ist es das Kommando
--          TOP statt LIMIT


-- Die Zuordnungstabelle gibt an, welcher Schauspieler
-- welche Rolle in welchem Film hatte. Geben Sie diese
-- sinnvoll aus:
SELECT
    -- CONCAT fügt den Inhalt von Feldern in Eines
    -- zusammen.
    CONCAT(a.FirstName, ' ', a.LastName) AS Actor,
    f.titleEN AS 'Titel',
    r.name AS 'Rolle'
FROM movies.`film_actor` z -- Kurzschreibweise: lasse AS weg
-- beliebig viele LEFT JOIN hintereinander
LEFT JOIN movies.actors a
    ON z.actor = a.id
LEFT JOIN movies.film f
    ON z.film = f.id
LEFT JOIN movies.role r
    ON z.role = r.id
ORDER BY Actor ASC;
-- MariaDB kann nach einem Feld sortieren, welches nur
-- in diesem Befehl definiert ist.

-- ------------------------------------------------------------
-- DONNERSTAG 25.07.2019
-- ------------------------------------------------------------

-- ! BEISPIEL FÜR EINEN KLASSISCHEN FEHLER:
SELECT primaryGenre, titleEn, AVG(myRating) 
FROM `film` 
GROUP BY primaryGenre;
-- nach titleEn wurde nicht gruppiert
-- Trotzdem wählt MariaDB einen zufälligen (!) Wert aus der Spalte aus.
-- Andere Datenbanksysteme führen einen solchen Befehl 
-- nicht aus und werten das als Syntaxfehler.
-- Das strenge Verhalten kann man bei MariaDB aktivieren,
-- aber per default ist es aus.


-- Wenn Sie gruppieren, werden Aggregatfunktionen auf die jeweilige
-- Gruppe angewandt.
SELECT
    g.genrename AS Genre,
    COUNT(*) AS Anzahl,
    ROUND(AVG(myRating),2) AS `Durchschnitts-Rating`,
    MIN(myRating) AS `niedrigste Wertung`,
    MAX(myRating) AS `höchste Wertung`,
    ROUND(AVG(rottenTomatoesAvg),2) AS `RT`
FROM movies.film AS f
LEFT JOIN movies.genre AS g
    ON f.primaryGenre = g.id
GROUP BY primaryGenre 
HAVING Anzahl > 5 
ORDER BY Anzahl;

-- ------------------------------------------------------------
-- FREITAG 26.07.2019
-- ------------------------------------------------------------

