#Comandos para desplegar el contenedor

docker build -t crudPET .
docker run -d -p 8091:80 -p 2222:22 crudPET





