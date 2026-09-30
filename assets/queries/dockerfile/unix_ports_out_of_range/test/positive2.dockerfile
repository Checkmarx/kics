from gliderlabs/alpine:3.3
run apk --no-cache add nginx
expose 65536/tcp 80 443 22
cmd ["nginx", "-g", "daemon off;"]