# ANTLR builder
FROM adoptopenjdk/openjdk11:alpine AS antlr_builder

WORKDIR /opt/antlr4

ARG ANTLR_VERSION="4.9.2"
ARG MAVEN_OPTS="-Xmx1G"

RUN apk add --no-cache maven git \
    && git clone https://github.com/antlr/antlr4.git \
    && cd antlr4 \
    && git checkout $ANTLR_VERSION \
    && mvn clean --projects tool --also-make \
    && mvn -DskipTests install --projects tool --also-make \
    && mv ./tool/target/antlr4-*-complete.jar antlr4-tool.jar

# Parser generator
FROM adoptopenjdk/openjdk11:alpine-jre AS antlr_generator

ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --no-create-home \
    --uid "${uid}" \
    "${user}"

COPY --from=builder /opt/antlr4/antlr4/antlr4-tool.jar /usr/local/lib/
WORKDIR /app
COPY pkg/parser/json_filter .
RUN ["java", "-Xmx500M", "-cp", "/usr/local/lib/antlr4-tool.jar", "org.antlr.v4.Tool", "-Dlanguage=Go", "-visitor", "-no-listener", "-o /app/json_filter/parser", "/app/json_filter/JSONFilter.g4"]

FROM golang:1.17.0-alpine as build_env
# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""
ARG DESCRIPTIONS_URL=""

# Copy go mod and sum files
COPY --chown=Checkmarx:Checkmarx go.mod .
COPY --chown=Checkmarx:Checkmarx go.sum .
# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x
# COPY the source code as the last step
COPY . .
# COPY generated
COPY --from=antlr_generator /app/json_filter/parser pkg/parser/json_filter/parser
# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
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
