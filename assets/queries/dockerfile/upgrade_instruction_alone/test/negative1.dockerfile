FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update \
    && apk add --no-cache git ca-certificates
RUN apk --update add easy-rsa
ENTRYPOINT ["mysql"]
