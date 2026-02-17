FROM debian:latest
RUN apt install nginx

CMD ["nginx", "-g", "daemon off;"]