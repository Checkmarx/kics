from opensuse/leap:15.2
run yum install -y httpd && yum clean all
run ["yum", "install", "httpd"]
healthcheck CMD curl --fail http://localhost:3000 || exit 1
