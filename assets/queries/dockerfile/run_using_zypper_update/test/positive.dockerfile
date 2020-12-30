FROM busybox:1.0
RUN zypper update -y
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
