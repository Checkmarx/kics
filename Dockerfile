FROM cgr.dev/chainguard/go@sha256:1b27d8f2f9bb49434e38fbb7456cb8b72b6652235bb07e2ee002d06f44821c29 as build_env

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ENV GIT_VERSION=2.46.0
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""
ARG DESCRIPTIONS_URL=""
ARG TARGETOS
ARG TARGETARCH

# Copy go mod and sum files
COPY go.mod go.sum  ./

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x

# COPY the source code as the last step
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/v2/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/v2/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/v2/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/v2/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go

USER nonroot

# Runtime image
# Ignore no User Cmd since KICS container is stopped afer scan
# kics-scan ignore-line
FROM cgr.dev/chainguard/bash@sha256:2faccc3e8ab049d82dec0e4d2dd8b45718c71ce640608584d95a39092b5006b5

RUN curl -LO https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz && \
    tar -zxf v${GIT_VERSION}.tar.gz && \
    mv git-${GIT_VERSION}/bin/git /usr/local/bin/git && \
    chmod +x /usr/local/bin/git && \
    rm -rf git-${GIT_VERSION} v${GIT_VERSION}.tar.gz

ENV TERM xterm-256color

# Copy built binary to the runtime container
# Vulnerability fixed in latest version of KICS remove when gh actions version is updated
# kics-scan ignore-line
COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/queries /app/bin/assets/queries
COPY --from=build_env /app/assets/cwe_csv /app/bin/assets/cwe_csv
COPY --from=build_env /app/assets/libraries/* /app/bin/assets/libraries/

WORKDIR /app/bin

# Healthcheck the container
ENV PATH $PATH:/app/bin

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]