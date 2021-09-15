# Running KICS in TravisCI

You can integrate KICS into your Travis CI/CD pipelines.

This provides you the ability to run KICS scans in your repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).


# Example configuration using docker

```yaml
services:
  - docker

before_install:
  - docker pull checkmarx/kics:latest-alpine

script:
  - docker run -v ${PWD}/path checkmarx/kics:latest scan -p /path -o ${PWD} --ci --ignore-on-exit results
```

# Example configuration downloading binaries

```yaml
env:
  global:
    - LATEST_VERSION=1.4.2

install:
  - mkdir ./tmp
  - wget -q https://github.com/Checkmarx/kics/releases/download/v${LATEST_VERSION}/kics_${LATEST_VERSION}_Linux_x64.tar.gz -O ./tmp/kics.tar.gz
  - tar xfzv ./tmp/kics.tar.gz -C ./tmp

script:
  - ./tmp/kics scan -p ${PWD}/path -o ${PWD} --exclude-paths ./tmp --ci --ignore-on-exit results
```
