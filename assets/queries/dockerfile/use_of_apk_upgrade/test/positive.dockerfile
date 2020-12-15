FROM alpine:3.7
RUN apk update \
    && apk upgrade \
    && apk add kubectl=1.20.0-r0 \
    && rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]

FROM alpine:3.9
RUN apk update
RUN apk update && apk upgrade && apk add kubectl=1.20.0-r0 \
    && rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]
