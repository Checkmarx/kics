FROM fedora:latest
RUN dnf install nginx

CMD ["nginx", "-g", "daemon off;"]