from golang:1.12.0-stretch
workdir /go
copy . /go
run top
run ["ps", "-d"]
cmd ["go", "run", "main.go"]
