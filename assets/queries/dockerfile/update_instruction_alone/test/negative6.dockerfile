FROM opensuse:latest
RUN zypper refresh && zypper install nginx

CMD ["nginx", "-g", "daemon off;"]