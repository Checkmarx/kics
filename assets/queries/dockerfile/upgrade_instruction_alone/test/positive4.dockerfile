FROM centos:latest
RUN apt update
RUN yum install nginx

CMD ["nginx", "-g", "daemon off;"]