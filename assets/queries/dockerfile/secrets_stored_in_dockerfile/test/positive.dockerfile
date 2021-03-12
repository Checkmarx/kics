FROM golang:1.7.3
WORKDIR /go/src/github.com/alexellis/href-counter/
COPY app.go .
ENV admin_password 123123F
LABEL api_secret="abcdef12345"
RUN asadmin --user=admin --passwordfile=payarapwd change-admin-password
RUN go get -d -v golang.org/x/net/html \
  && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
