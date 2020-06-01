FROM php:7.2-apache

RUN apt-get update && apt-get install -y vim

COPY conf/ /etc/apache2
# ligne en dessous pose trop de probleme voir readme
COPY apache2-foreground /usr/local/bin/

# les commandes pour activer les modes et la conf
RUN a2enmod proxy proxy_http
RUN a2ensite 000-default.conf 001-reverse-proxy.conf
