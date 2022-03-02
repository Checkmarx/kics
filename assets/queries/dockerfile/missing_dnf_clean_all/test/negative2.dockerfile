FROM golang:1.16 AS builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
RUN set -uex && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    sed -i 's/\$releasever/26/g' /etc/yum.repos.d/docker-ce.repo && \
    dnf install -vy docker-ce

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app ./
CMD ["./app"]
RUN useradd -ms /bin/bash patrick

USER patrick
