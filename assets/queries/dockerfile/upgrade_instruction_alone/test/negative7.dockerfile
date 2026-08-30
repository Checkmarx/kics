FROM debian:latest
RUN apt update && install nginx

CMD ["nginx", "-g", "daemon off;"]