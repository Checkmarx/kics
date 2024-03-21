# example with envs usage

FROM ubuntu

ENV OPENSSL3_URL  "https://www.openssl.org/source/openssl-1.1.1h.tar.gz"

RUN apk update \
    && apk upgrade \
    && apk add make gcc

RUN yum -y install \
    && yum clean all \
    && wget ${OPENSSL3_URL}
