# example with envs usage

FROM ubuntu

ENV OPENSSL3_URL="https://www.openssl.org/source/openssl-3.0.2.tar.gz"

RUN ["wget", "-O-", "${OPENSSL3_URL}"]
