#!/bin/bash

# Iniciar MariaDB
mysqld_safe &

# Esperar a que MariaDB esté listo
sleep 5

# Ejecutar el script de inicialización
mysql -u root < /docker-entrypoint-initdb.d/create_db.sql

# Iniciar Apache
apachectl -D FOREGROUND
