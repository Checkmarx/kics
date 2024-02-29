FROM alpine:latest
RUN apk add nginx

CMD ["nginx", "-g", "daemon off;"]