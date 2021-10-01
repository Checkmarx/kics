FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.17.1-alpine as build_env

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""
ARG DESCRIPTIONS_URL=""
ARG TARGETOS
ARG TARGETARCH

# Copy go mod and sum files
COPY go.mod .
COPY go.sum .

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x

# COPY the source code as the last step
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go
USER Checkmarx

# Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

# Runtime image
FROM alpine:3.14.2

# Install Git
RUN apk add --no-cache \
    git=2.32.0-r0

# Copy built binary to the runtime container
COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/ /app/bin/assets/

WORKDIR /app/bin

# Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt
ENV PATH $PATH:/app/bin

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
