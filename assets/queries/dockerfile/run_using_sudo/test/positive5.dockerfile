FROM alpine:3.5
RUN apk add --update py2-pip
RUN ["sudo", "pip", "install", "--upgrade", "pip"]
RUN ["sudo", "apt-get", "install", "-y", "vim"]