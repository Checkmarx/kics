FROM golang:1.16-alpine as build_env

# Create a group and user
RUN addgroup -S Checkmarx && adduser -S Checkmarx -G Checkmarx
USER Checkmarx

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION="development"
ARG COMMIT="NOCOMMIT"
ARG SENTRY_DSN=""

#Copy go mod and sum files
COPY --chown=Checkmarx:Checkmarx go.mod .
COPY --chown=Checkmarx:Checkmarx go.sum .

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download

# COPY the source code as the last step
COPY . .

USER root

# Install git
RUN apk add --no-cache \
    git=2.32.0-r0

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags "-s -w -X github.com/Checkmarx/kics/internal/constants.Version=${VERSION} -X github.com/Checkmarx/kics/internal/constants.SCMCommit=${COMMIT} -X github.com/Checkmarx/kics/internal/constants.SentryDSN=${SENTRY_DSN}" \
    -a -installsuffix cgo \
    -o bin/kics cmd/console/main.go
USER Checkmarx

#Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

#runtime image
FROM scratch


# Copy git execution folders
COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets /app/bin/assets
COPY --from=build_env /lib/ /lib/
COPY --from=build_env /usr/lib/ /usr/lib/
COPY --from=build_env /usr/libexec/git-core /usr/libexec/git-core
COPY --from=build_env /usr/sbin/update-ca-certificates /usr/sbin/update-ca-certificates
COPY --from=build_env /usr/share/git-core /usr/share/git-core
COPY --from=build_env /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=build_env /usr/bin/c_rehash /usr/bin/c_rehash
COPY --from=build_env /usr/bin/git /usr/bin/git
COPY --from=build_env /usr/bin/git-receive-pack  /usr/bin/git-receive-pack
COPY --from=build_env /usr/bin/git-shell /usr/bin/git-shell
COPY --from=build_env /usr/bin/git-upload-archive /usr/bin/git-upload-archive
COPY --from=build_env /usr/bin/git-upload-pack /usr/bin/git-upload-pack
COPY --from=build_env /etc/ca-certificates.conf /etc/ca-certificates.conf
COPY --from=build_env /etc/ca-certificates/update.d/certhash /etc/ca-certificates/update.d/certhash
COPY --from=build_env /etc/apk/protected_paths.d/ca-certificates.list /etc/apk/protected_paths.d/ca-certificates.list
COPY --from=build_env /etc/ssl/certs /etc/ssl/certs
COPY --from=build_env /bin /bin

WORKDIR /app/bin

#Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
