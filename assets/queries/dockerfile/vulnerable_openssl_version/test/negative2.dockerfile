# example with args usage

FROM ubuntu

ARG OPENSSL_VERSION=1.1.1h

RUN curl https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
