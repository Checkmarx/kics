FROM busybox:1.0
RUN zypper install -y httpd=2.4 && zypper clean
RUN zypper patch --cve=cve-2015-7547 && zypper clean
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
