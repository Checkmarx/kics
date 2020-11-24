FROM golang:1.15.3-alpine3.12 as build_env

ARG GIT_USER
ARG GIT_TOKEN

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*

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
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o bin/kics cmd/kics/main.go cmd/kics/config.go

#runtime image
FROM alpine:3.11.3

RUN apk add --no-cache  git

COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets /app/assets

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
