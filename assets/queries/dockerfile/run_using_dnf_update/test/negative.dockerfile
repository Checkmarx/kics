FROM fedora:28
RUN dnf install -y nginx \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum