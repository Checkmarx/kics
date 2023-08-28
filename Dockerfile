FROM golang:1.20.2-alpine as build_env

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
FROM alpine:3.17.3

ENV TERM xterm-256color

# Install Terraform and Terraform plugins
RUN wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip \
    && unzip terraform_1.3.9_linux_amd64.zip && rm terraform_1.3.9_linux_amd64.zip \
    && mv terraform /usr/bin/terraform \
    && wget https://releases.hashicorp.com/terraform-provider-azurerm/3.18.0/terraform-provider-azurerm_3.18.0_linux_amd64.zip \
    && wget https://releases.hashicorp.com/terraform-provider-aws/3.72.0/terraform-provider-aws_3.72.0_linux_amd64.zip \
    && wget https://releases.hashicorp.com/terraform-provider-google/4.32.0/terraform-provider-google_4.32.0_linux_amd64.zip \
    && unzip terraform-provider-azurerm_3.18.0_linux_amd64.zip && rm terraform-provider-azurerm_3.18.0_linux_amd64.zip\
    && unzip terraform-provider-google_4.32.0_linux_amd64.zip && rm terraform-provider-google_4.32.0_linux_amd64.zip \
    && unzip terraform-provider-aws_3.72.0_linux_amd64.zip && rm terraform-provider-aws_3.72.0_linux_amd64.zip \
    && mkdir ~/.terraform.d && mkdir ~/.terraform.d/plugins && mkdir ~/.terraform.d/plugins/linux_amd64 && mv terraform-provider-aws_v3.72.0_x5 terraform-provider-google_v4.32.0_x5 terraform-provider-azurerm_v3.18.0_x5 ~/.terraform.d/plugins/linux_amd64 \
    && apk upgrade --no-cache pcre2 \
    && apk add --no-cache \
    git~=2.38


# Install Terraformer
RUN wget https://github.com/GoogleCloudPlatform/terraformer/releases/download/0.8.22/terraformer-all-linux-amd64 \
    && chmod +x terraformer-all-linux-amd64 \
    && mv terraformer-all-linux-amd64 /usr/bin/terraformer \
    && apk add gcompat=1.1.0-r0 --no-cache


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
