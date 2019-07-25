# Aufbau einer Datenbankverbindung mit Python


* **connect-to-db.py** enthält den eigentlichen Code zum Aufbau der Verbindung
* **config.py** enthält getrennt davon die nötigen Parameter zum Verbindungsaufbau (insbesondere Username und Password). Diese sollten normalerweise außerhalb des Repository gespeichert werden.

Libraries:


* [pymsql](https://github.com/PyMySQL/PyMySQL) für Verbindungen zu MySQL und MariaDB
