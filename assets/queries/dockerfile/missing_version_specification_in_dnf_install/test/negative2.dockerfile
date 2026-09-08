from fedora:latest
run dnf -y update && dnf -y install httpd-2.24.2 && dnf clean all
run ["dnf", "install", "httpd-2.24.2"]
copy index.html /var/www/html/index.html
expose 80
entrypoint /usr/sbin/httpd -DFOREGROUND
