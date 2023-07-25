FROM alpine:latest
RUN apk update && apk add nginx

CMD ["nginx", "-g", "daemon off;"]