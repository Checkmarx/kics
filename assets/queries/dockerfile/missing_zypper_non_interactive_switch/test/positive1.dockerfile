FROM busybox:1.0
RUN zypper install httpd && zypper clean
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
