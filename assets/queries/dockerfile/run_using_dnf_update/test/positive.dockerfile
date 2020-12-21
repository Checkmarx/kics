FROM fedora:28
RUN dnf update
RUN dnf install -y nginx \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum