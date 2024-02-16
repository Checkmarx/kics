FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y --no-install-recommends mysql-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk update
ENTRYPOINT ["mysql"]