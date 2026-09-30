from alpine:latest
run apk update
run apk add nginx

cmd ["nginx", "-g", "daemon off;"]