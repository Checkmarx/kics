FROM golang:1.12.0-stretch
WORKDIR /go
COPY . /go
RUN top
RUN ["ps", "-d"]
CMD ["go", "run", "main.go"]
