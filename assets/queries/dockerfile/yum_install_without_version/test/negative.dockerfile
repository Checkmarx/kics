FROM opensuse/leap:15.2
RUN yum install -y httpd-2.24.2 && yum clean all
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
