FROM alpine:latest
RUN apk update && apk add nginx
RUN apk --update-cache add vim
RUN apk -U add nano

CMD ["nginx", "-g", "daemon off;"]