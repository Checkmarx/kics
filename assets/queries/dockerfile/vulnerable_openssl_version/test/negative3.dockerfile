# example with args usage

FROM ubuntu

ARG OPENSSL_SRC=https://www.openssl.org/source/openssl-1.1.1h.tar.gz

RUN curl ${OPENSSL_SRC}
