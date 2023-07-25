FROM fedora:latest
RUN dnf update
RUN dnf install nginx

CMD ["nginx", "-g", "daemon off;"]