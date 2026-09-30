from gliderlabs/alpine:3.3
run apk --no-cache add nginx
expose 3000 80 443 22
cmd ["nginx", "-g", "daemon off;"]
