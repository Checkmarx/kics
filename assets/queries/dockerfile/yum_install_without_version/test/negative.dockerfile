FROM opensuse/leap:15.2
RUN yum install -y httpd-2.24.2 && yum clean all
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1


FROM opensuse/leap:15.3
ENV RETHINKDB_PACKAGE_VERSION 2.4.0~0trusty
RUN yum install -y rethinkdb-$RETHINKDB_PACKAGE_VERSION && yum clean all
