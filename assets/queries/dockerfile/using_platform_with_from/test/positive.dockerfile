FROM alpine:3.5
RUN apk add --update py2-pip
RUN pip install --upgrade pip
LABEL maintainer="SvenDowideit@home.org.au"
COPY requirements.txt /usr/src/app/
FROM baseimage as baseimage-build
