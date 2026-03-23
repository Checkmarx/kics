from ubuntu:18.04
run apt-get update \
    && apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
run apk update \
    && apk add --no-cache git ca-certificates
run apk --update add easy-rsa
entrypoint ["mysql"]
