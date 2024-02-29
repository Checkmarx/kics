FROM centos:latest
RUN yum update && yum install nginx

CMD ["nginx", "-g", "daemon off;"]