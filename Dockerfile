FROM golang:1.13.7-alpine3.11 as build_env

ARG GIT_USER
ARG GIT_TOKEN

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/checkmarxDev/*

RUN apk add --no-cache git \
     && git config \
      --global \
      url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
      "https://github.com"


#Copy go mod and sum files
COPY go.mod .
COPY go.sum .

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download

# COPY the source code as the last step
COPY . .


# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o bin/ice cmd/ice/main.go cmd/ice/config.go

#runtime image
FROM alpine:3.11.3

RUN apk add --no-cache  git

COPY --from=build_env /app/bin/ice /app/bin/ice

# Command to run the executable
ENTRYPOINT ["/app/bin/ice"]