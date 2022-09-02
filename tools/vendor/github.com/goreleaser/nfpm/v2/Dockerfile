FROM alpine
COPY nfpm_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/nfpm_*.apk
ENTRYPOINT ["/usr/bin/nfpm"]
