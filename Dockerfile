FROM golang:1.16.2-alpine3.12 as build_env

# Create a group and user
RUN addgroup -S Checkmarx && adduser -S Checkmarx -G Checkmarx
USER Checkmarx

# Copy the source from the current directory to the Working Directory inside the container
WORKDIR /app

ENV GOPRIVATE=github.com/Checkmarx/*
ARG VERSION=development

#Copy go mod and sum files
COPY --chown=Checkmarx:Checkmarx go.mod .
COPY --chown=Checkmarx:Checkmarx go.sum .

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download

# COPY the source code as the last step
COPY . .

USER root
# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
  -ldflags "-X github.com/Checkmarx/kics/internal/constants.Version=${VERSION}" -a -installsuffix cgo \
  -o bin/kics cmd/console/main.go
USER Checkmarx

#Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

#runtime image
FROM scratch

COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/ /app/bin/assets/

WORKDIR /app/bin

#Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
