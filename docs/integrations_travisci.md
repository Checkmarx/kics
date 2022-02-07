# Running KICS in TravisCI

You can integrate KICS into your Travis CI/CD pipelines.

This provides you the ability to run KICS scans in your repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

# Example configuration using docker

```yaml
services:
    - docker

before_install:
    - docker pull checkmarx/kics:latest

script:
    - docker run -v ${PWD}/path checkmarx/kics:latest scan -p /path -o ${PWD} --ci --ignore-on-exit results
```
