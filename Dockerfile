# Usar Debian estable en lugar de bitnami/minideb para evitar problemas
FROM debian:bullseye

ENV DEBIAN_FRONTEND="noninteractive"

# Actualizar repositorios y preparar la instalación
RUN sed -i 's/^# deb-src/deb-src/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y apache2 perl openssh-server locales vim bash tree dos2unix && \
    apt-get install -y mariadb-server libmariadb-dev locales && \
    apt-get install -y build-essential libssl-dev libcurl4-openssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar las locales para UTF-8
RUN echo 'es_PE.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    export LANG=es_PE.UTF-8 && \
    export LC_ALL=es_PE.UTF-8           

# Configurar MariaDB   
COPY ./db-init/create_db.sql /docker-entrypoint-initdb.d/

# Instalar dependencias necesarias para Perl
RUN apt-get update && apt-get install -y cpanminus libdbd-mysql-perl
RUN cpanm JSON

# Configurar Apache para CGI
RUN apt-get update && apt-get install -y apache2 && \
    a2enmod cgi && \
    echo '<VirtualHost *:80>\n\
    ServerAdmin webmaster@localhost\n\
    DocumentRoot /var/www/html\n\
    ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/\n\
    <Directory "/usr/lib/cgi-bin">\n\
        AllowOverride None\n\
        Options +ExecCGI\n\
        Require all granted\n\
    </Directory>\n\
    <Directory \"/var/www/html\">\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride None\n\
        Require all granted\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Copiar los scripts CGI al contenedor
COPY ./cgi-bin/ /usr/lib/cgi-bin/
RUN find /usr/lib/cgi-bin/ -type f -exec dos2unix {} \; && chmod +x /usr/lib/cgi-bin/*



# Copiar los recursos JS al contenedor
COPY ./js/ /var/www/html/js/
RUN find /var/www/html/js/ -type f -exec dos2unix {} \;

# Copiar el script de inicio al contenedor
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Exponer los puertos
EXPOSE 22
EXPOSE 80

# Establecer el comando de inicio
CMD ["/start.sh"]

#CMD service mysql start && \
 #   mysql -u root < /docker-entrypoint-initdb.d/create_db.sql

#CMD ["apachectl", "-D", "FOREGROUND"]
