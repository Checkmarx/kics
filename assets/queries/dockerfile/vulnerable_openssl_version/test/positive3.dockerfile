# example with args usage

FROM ubuntu

ARG OPENSSL_SRC=https://www.openssl.org/source/openssl-3.0.4.tar.gz

RUN curl ${OPENSSL_SRC}
