FROM opensuse/leap:15.2
RUN zypper install -y httpd=2.4.46 && zypper clean
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
