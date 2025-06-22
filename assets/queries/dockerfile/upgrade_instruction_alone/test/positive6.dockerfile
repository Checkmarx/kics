FROM archlinux:latest
RUN pacman -S nginx

CMD ["nginx", "-g", "daemon off;"]