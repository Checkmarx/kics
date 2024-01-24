FROM golang:1.7.3
WORKDIR /go/src/github.com/foo/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
ENTRYPOINT [ "/opt/app/run.sh", "--port", "8080" ]

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/foo/href-counter/app .
ENTRYPOINT [ "/opt/app/run.sh", "--port", "8080" ]