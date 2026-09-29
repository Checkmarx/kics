FROM gliderlabs/alpine:3.3
RUN apk --no-cache add nginx
EXPOSE 65536/tcp 80 443 22
CMD ["nginx", "-g", "daemon off;"]