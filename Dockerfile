FROM --platform=linux/amd64 cgr.dev/chainguard/go@sha256:4d51574ef33b4edc57a22da062fe335a500eda30a1f1315cb39b4977bf2aef5f as build_env

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
COPY go.mod go.sum  ./

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x

# COPY the source code as the last step
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go

USER nonroot

# Runtime image
# Ignore no User Cmd since KICS container is stopped afer scan
# kics-scan ignore-line
FROM --platform=linux/amd64 cgr.dev/chainguard/git@sha256:de87d065b0efb4332080a55ccf45015891fce6aa9ee6101730779850d4634a56

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
