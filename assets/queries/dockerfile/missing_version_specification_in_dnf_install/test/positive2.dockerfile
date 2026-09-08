from fedora:latest
run dnf -y update && dnf -y install httpd && dnf clean all
run ["dnf", "install", "httpd"]
copy index.html /var/www/html/index.html
expose 80
entrypoint /usr/sbin/httpd -DFOREGROUND
