FROM fedora:latest
RUN dnf -y update && dnf -y install httpd-2.24.2 && dnf clean all
COPY index.html /var/www/html/index.html
EXPOSE 80
ENTRYPOINT /usr/sbin/httpd -DFOREGROUND