FROM alpine:latest
RUN apk --update add nginx
RUN apk add --update nginx

CMD ["nginx", "-g", "daemon off;"]