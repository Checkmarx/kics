# example with args usage

FROM ubuntu

ARG OPENSSL_VERSION=3.0.5

RUN curl https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
