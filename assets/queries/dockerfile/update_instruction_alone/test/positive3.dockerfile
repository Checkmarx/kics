FROM debian:latest
RUN apt update
RUN apt install nginx

CMD ["nginx", "-g", "daemon off;"]