FROM php:7.2-apache

COPY conf/ /etc/apache2


# les commandes pour activer les modes et la conf

RUN a2enmod proxy proxy_http
RUN a2ensite 000-default.conf 001-reverse-proxy.conf

