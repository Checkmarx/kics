FROM alpine:2.6
USER root
RUN npm install
USER 1000:0
