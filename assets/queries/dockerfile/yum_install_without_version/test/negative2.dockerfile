from opensuse/leap:15.2
run yum install -y httpd-2.24.2 && yum clean all
healthcheck CMD curl --fail http://localhost:3000 || exit 1


from opensuse/leap:15.3
env RETHINKDB_PACKAGE_VERSION 2.4.0~0trusty
run yum install -y rethinkdb-$RETHINKDB_PACKAGE_VERSION && yum clean all
