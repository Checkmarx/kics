ARG GO_BASE_IMAGE=checkmarx/go:1.26.4@sha256:9e7f3dd6ceeb3252b7dd844a6152f43518aa7a7c21ff196525cd45a0a8fdbfba
ARG GIT_BASE_IMAGE=checkmarx/git:2.55.0@sha256:c1d0c185d7ad77c99c1c9323770220c449cba6a6065dd3a78a8fa8794da5741f
FROM ${GO_BASE_IMAGE} AS build_env

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""
ARG DESCRIPTIONS_URL=""
ARG TARGETOS
ARG TARGETARCH
ARG CGO_ENABLED=0

# Copy go mod and sum files
COPY go.mod go.sum  ./

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x

# COPY the source code as the last step
COPY . .

# Build the Go app
RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/v2/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/v2/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/v2/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/v2/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go

# Runtime image
# Ignore no User Cmd since KICS container is stopped afer scan
# kics-scan ignore-line
FROM ${GIT_BASE_IMAGE}

ENV TERM=xterm-256color

# Copy built binary to the runtime container
# Vulnerability fixed in latest version of KICS remove when gh actions version is updated
# kics-scan ignore-line
COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/queries /app/bin/assets/queries
COPY --from=build_env /app/assets/cwe_csv /app/bin/assets/cwe_csv
COPY --from=build_env /app/assets/similarityID_transition  /app/bin/assets/similarityID_transition
COPY --from=build_env /app/assets/libraries/* /app/bin/assets/libraries/

WORKDIR /app/bin

USER root

# Healthcheck the container
ENV PATH=$PATH:/app/bin

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
