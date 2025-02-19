FROM opensuse:latest
RUN zypper install nginx

CMD ["nginx", "-g", "daemon off;"]