FROM alpine:latest
RUN apk update
RUN apk add nginx

CMD ["nginx", "-g", "daemon off;"]