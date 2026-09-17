from golang:1.7.3
workdir /go/src/github.com/foo/href-counter/
run go get -d -v golang.org/x/net/html  
copy app.go .
run CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

from alpine:latest  
run apk --no-cache add ca-certificates
workdir /root/
copy --from=0 /go/src/github.com/foo/href-counter/app .
cmd ["./app"] 
cmd ["./apps"] 
