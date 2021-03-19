FROM gliderlabs/alpine:3.3
RUN apk --no-cache add nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
