FROM opensuse:latest
RUN zypper refresh
RUN zypper install nginx

CMD ["nginx", "-g", "daemon off;"]