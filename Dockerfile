FROM checkmarx/go:1.25.1-r0-a5f6a49d313296@sha256:a5f6a49d313296a88aa414aa028035be91b9683330f8201ad2cd0747ba821c5b AS build_env

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
    -ldflags "-s -w -X github.com/Checkmarx/kics/v2/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/v2/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/v2/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/v2/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go

# Runtime image
# Ignore no User Cmd since KICS container is stopped afer scan
# kics-scan ignore-line
FROM checkmarx/git:2.51.0-r1-b329c83e6a5a90@sha256:b329c83e6a5a90bafb24b7ef1ffffba7dac164df4cede2a00ede9c6084cbf876

ENV TERM xterm-256color

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
ENV PATH $PATH:/app/bin

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
