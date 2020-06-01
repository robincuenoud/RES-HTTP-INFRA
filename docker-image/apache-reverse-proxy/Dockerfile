FROM php:7.2-apache

RUN apt-get update && apt-get install -y vim

COPY conf/ /etc/apache2
COPY templates /var/apache2/templates
COPY jenaimarre /var/apache2/
# les commandes pour activer les modes et la conf
RUN a2enmod proxy proxy_http
#fonctionne pas en dessous
#RUN php /var/apache2/templates/conf-template.php > /etc/apache2/sites-available/001-reverse-proxy.conf
#on run donc mon script
RUN ./var/apache2/jenaimarre
RUN a2ensite 000-default.conf 001-reverse-proxy.conf

