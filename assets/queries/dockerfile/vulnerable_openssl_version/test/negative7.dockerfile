# example with envs usage

FROM ubuntu

ENV OPENSSL3_URL="https://www.openssl.org/source/openssl-1.1.1h.tar.gz"

RUN ["curl", "${OPENSSL3_URL}"]
