FROM golang:1.16-alpine as build_env
# Create a group and user
ARG UID=1000
ARG GID=1000

RUN addgroup -S -g ${GID} Checkmarx && adduser -S -D -u ${UID} Checkmarx -G Checkmarx
USER ${UID}
# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""
ARG DESCRIPTIONS_URL=""

#Copy go mod and sum files
COPY --chown=Checkmarx:Checkmarx go.mod .
COPY --chown=Checkmarx:Checkmarx go.sum .
# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download -x
# COPY the source code as the last step
COPY . .
USER root
# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/internal/constants.SentryDSN=${SENTRY_DSN} -X github.com/Checkmarx/kics/internal/constants.BaseURL=${DESCRIPTIONS_URL}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go && \
    chown -R Checkmarx:0 /app && \
    chmod -R g=u /app
USER ${UID}
#Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt
#runtime image
FROM alpine:3.14.1

ARG UID=1000
ARG GID=1000

COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/ /app/bin/assets/  

# Install Git
RUN apk add --no-cache \
    git=2.32.0-r0 && \
    addgroup -S -g ${GID} Checkmarx && \
    adduser -S -D -u ${UID} Checkmarx -G Checkmarx && \
    chown -R Checkmarx:0 /app/bin && \
    chmod -R g=u /app/bin
                                         
USER ${UID}

WORKDIR /app/bin

# Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt
ENV PATH $PATH:/app/bin
ENV PWD=/app/bin/assets/queries
# Command to run the executable

ENTRYPOINT ["/app/bin/kics"]
