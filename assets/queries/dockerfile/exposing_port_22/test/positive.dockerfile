FROM gliderlabs/alpine:3.3
RUN apk --no-cache add nginx
EXPOSE 3000 80 443 22
CMD ["nginx", "-g", "daemon off;"]
