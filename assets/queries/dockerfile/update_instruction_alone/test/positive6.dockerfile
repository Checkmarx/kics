FROM archlinux:latest
RUN pacman -Syu
RUN pacman -S nginx

CMD ["nginx", "-g", "daemon off;"]