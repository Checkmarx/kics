FROM fedora:latest
RUN dnf update && dnf install nginx

CMD ["nginx", "-g", "daemon off;"]