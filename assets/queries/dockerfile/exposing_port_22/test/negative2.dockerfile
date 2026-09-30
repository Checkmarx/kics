from gliderlabs/alpine:3.3
run apk --no-cache add nginx
expose 80
cmd ["nginx", "-g", "daemon off;"]
