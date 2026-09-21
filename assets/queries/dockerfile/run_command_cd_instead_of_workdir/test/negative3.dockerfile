from nginx
env AUTHOR=Docker
workdir /usr/share/nginx/html
copy Hello_docker.html /usr/share/nginx/html
cmd cd /usr/share/nginx/html && sed -e s/Docker/"$AUTHOR"/ Hello_docker.html > index.html ; nginx -g 'daemon off;'