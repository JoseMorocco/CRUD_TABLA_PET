CREATE DATABASE menagerie;
CREATE USER 'pet'@'localhost' IDENTIFIED BY '12345678';
GRANT ALL PRIVILEGES ON menagerie.* TO 'pet'@'localhost';
FLUSH PRIVILEGES;

USE menagerie;

CREATE TABLE pet (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    owner VARCHAR(20),
    species VARCHAR(20),
    sex CHAR(1),
    birth DATE,
    death DATE
);

INSERT INTO pet (id, name, owner, species, sex, birth, death) VALUES
(1, 'Fluffy', 'Harold', 'cat', 'f', '1993-02-04', NULL),
(2, 'Claws', 'Gwen', 'cat', 'm', '1994-03-17', NULL),
(3, 'Buffy', 'Harold', 'dog', 'f', '1989-05-13', NULL),
(4, 'Fang', 'Benny', 'dog', 'm', '1990-08-27', NULL),
(5, 'Bowser', 'Diane', 'dog', 'm', '1979-08-31', '1995-07-29'),
(6, 'Chirpy', 'Gwen', 'bird', 'f', '1998-09-11', NULL),
(7, 'Whistler', 'Gwen', 'bird', '', '1997-12-09', NULL),
(8, 'Slim', 'Benny', 'snake', 'm', '1996-04-29', NULL);