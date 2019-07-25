import logging
import pymysql

import config as cfg

try:
    # cfg. bedeutet die Variable ist in der oben importierten
    # config.py Datei definiert (Alias cfg).
    connection = pymysql.connect(host=cfg.DB_HOSTNAME,
                                 user=cfg.DB_USERNAME,
                                 password=cfg.DB_PASSPHRASE,
                                 database=cfg.DB_DATABASE,
                                 autocommit=True)

    db = connection.cursor()

    with db:
        db.execute("SELECT titleEn AS title " +
                   "FROM movies.film " +
                   "ORDER BY myRating DESC " +
                   "LIMIT 20;")
        movies = db.fetchall()

    for film in movies:
        print(film[0])

except Exception:
    logging.error("Fehler beim Datenbankzugriff\n", exc_info=True)
