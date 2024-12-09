

docker exec -it b8e4fb08eb81 /bin/bash


cat /var/log/apache2/error.log



docker build -t perl-mariadb_test4 .
docker run -d -p 8015:80 -p 2215:22 perl-mariadb_test4

docker ps -a


docker exec -it 9e8bb17ff564 bash


mysqld_safe &         iniciar  manualmente

mysql -u root -p
SHOW DATABASES;
SHOW TABLES;







root@f20c1735e6a0:/# mysqld_safe &
[1] 91
root@f20c1735e6a0:/# 241208 21:30:29 mysqld_safe Logging to syslog.
241208 21:30:29 mysqld_safe Starting mariadbd daemon with databases from /var/lib/mysql
mysqladmin ping
mysqld is alive
root@f20c1735e6a0:/# mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 5
Server version: 10.5.26-MariaDB-0+deb11u2 Debian 11

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use menagerie;
ERROR 1049 (42000): Unknown database 'menagerie'
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.002 sec)

MariaDB [(none)]> CREATE DATABASE menagerie;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| menagerie          |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.000 sec)

MariaDB [(none)]> USE menagerie;
Database changed
MariaDB [menagerie]> CREATE TABLE pet (
    ->     name VARCHAR(20),
    ->     owner VARCHAR(20),
    ->     species VARCHAR(20),
    ->     sex CHAR(1),
    ->     birth DATE,
    ->     death DATE
    -> );
Query OK, 0 rows affected (0.012 sec)

MariaDB [menagerie]> SELECT * FROM menagerie;
ERROR 1146 (42S02): Table 'menagerie.menagerie' doesn't exist
MariaDB [menagerie]> SELECT * FROM pet;
Empty set (0.023 sec)

MariaDB [menagerie]> SHOW TABLES;
+---------------------+
| Tables_in_menagerie |
+---------------------+
| pet                 |
+---------------------+
1 row in set (0.000 sec)

MariaDB [menagerie]> SELECT * FROM pet;
Empty set (0.000 sec)

MariaDB [menagerie]> INSERT INTO pet (name, owner, species, sex, birth, death) VALUES
    -> ('Fluffy', 'Harold', 'cat', 'f', '1993-02-04', NULL),
    -> ('Claws', 'Gwen', 'cat', 'm', '1994-03-17', NULL),
    -> ('Buffy', 'Harold', 'dog', 'f', '1989-05-13', NULL),
    -> ('Fang', 'Benny', 'dog', 'm', '1990-08-27', NULL),
    -> ('Bowser', 'Diane', 'dog', 'm', '1979-08-31', '1995-07-29'),
    -> ('Chirpy', 'Gwen', 'bird', 'f', '1998-09-11', NULL),
    -> ('Whistler', 'Gwen', 'bird', '', '1997-12-09', NULL),
    -> ('Slim', 'Benny', 'snake', 'm', '1996-04-29', NULL);
Query OK, 8 rows affected (0.003 sec)
Records: 8  Duplicates: 0  Warnings: 0

MariaDB [menagerie]> SELECT * FROM pert;
ERROR 1146 (42S02): Table 'menagerie.pert' doesn't exist
MariaDB [menagerie]> SELECT * FROM pet;
+----------+--------+---------+------+------------+------------+
| name     | owner  | species | sex  | birth      | death      |
+----------+--------+---------+------+------------+------------+
| Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
| Whistler | Gwen   | bird    |      | 1997-12-09 | NULL       |
| Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
+----------+--------+---------+------+------------+------------+
8 rows in set (0.000 sec)
