FROM golang:1.17.5-alpine as build_env

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
USER Checkmarx

# Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt

# Runtime image
# Ignore no User Cmd since KICS container is stopped afer scan
# kics-scan ignore-line
FROM alpine:3.14.3

# Install Terraform and Terraform plugins
RUN wget https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip
RUN unzip terraform_1.1.3_linux_amd64.zip && rm terraform_1.1.3_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN wget https://releases.hashicorp.com/terraform-provider-aws/3.72.0/terraform-provider-aws_3.72.0_linux_amd64.zip
RUN unzip terraform-provider-aws_3.72.0_linux_amd64.zip && rm terraform-provider-aws_3.72.0_linux_amd64.zip
RUN mkdir ~/.terraform.d && mkdir ~/.terraform.d/plugins && mkdir ~/.terraform.d/plugins/linux_amd64 && mv terraform-provider-aws_v3.72.0_x5 ~/.terraform.d/plugins/linux_amd64

# Install Git
RUN apk add --no-cache \
    git=2.32.0-r0

# Copy built binary to the runtime container
# Vulnerability fixed in latest version of KICS remove when gh actions version is updated
# kics-scan ignore-line
COPY --from=build_env /app/bin/kics /app/bin/kics
COPY --from=build_env /app/assets/queries /app/bin/assets/queries
COPY --from=build_env /app/assets/libraries/* /app/bin/assets/libraries/

WORKDIR /app/bin

# Healthcheck the container
HEALTHCHECK CMD wget -q --method=HEAD localhost/system-status.txt
ENV PATH $PATH:/app/bin

# Command to run the executable
ENTRYPOINT ["/app/bin/kics"]
