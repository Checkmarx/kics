ARG BASE_CONTAINER_REGISTRY

# Base the installer on the Azure CLI image as we require the tool
# to download the psa-check from the UniversalPackage feed.
# Additionally, the script to retrieve the Kubernetes schemas
# requires Python (yaml & requests) which are included by
# default in the Azure CLI image.
# hadolint ignore=DL3006
FROM ${BASE_CONTAINER_REGISTRY:-mcr.microsoft.com}/azure-cli AS installer

ARG AZP_URL
ARG AZP_TOKEN

ARG DCP_INSTALLATION=infra-test

ARG HADOLINT_VERSION=2.12.0
ARG KUSTOMIZE_VERSION=5.5.0
ARG KUBECONFORM_VERSION=0.6.7
ARG FLYWAY_VERSION=11.1.0

RUN tdnf install \
    jq \
    tar \
    libicu \
    python3-requests \
    python3-yaml
