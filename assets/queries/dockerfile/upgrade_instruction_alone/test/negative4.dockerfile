FROM archlinux:latest
RUN pacman -Syu && pacman -S nginx

CMD ["nginx", "-g", "daemon off;"]