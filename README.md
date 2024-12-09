#Comandos para desplegar el contenedor

docker build -t perl-mariadb_0 .



docker run -d -p 8091:80 -p 2222:22 perl-mariadb_0





