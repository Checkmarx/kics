FROM centos:latest
RUN yum update
RUN yum install nginx

CMD ["nginx", "-g", "daemon off;"]