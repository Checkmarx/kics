FROM fedora:latest
RUN dnf -y update && dnf -y install httpd && dnf clean all
RUN ["dnf", "install", "httpd"]
COPY index.html /var/www/html/index.html
EXPOSE 80
ENTRYPOINT /usr/sbin/httpd -DFOREGROUND
