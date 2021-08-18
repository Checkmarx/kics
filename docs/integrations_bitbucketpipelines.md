## Integrate KICS with Bitbucket Pipelines

You can integrate KICS into Bitbucket Pipelines CI/CD.

This provides you the ability to run KICS scans in your Bitbucket repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

### Example configuration

```yaml
image: atlassian/default-image:2

pipelines:
  default:
    - step:
        name: "Cx KICS"
        script:
          - LATEST_KICS_TAG=$(curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
          - LATEST_KICS_VERSION=${LATEST_KICS_TAG#v}
          - wget -q -c "https://github.com/Checkmarx/kics/releases/download/${LATEST_KICS_TAG}/kics_${LATEST_KICS_VERSION}_linux_x64.tar.gz" -O - | tar -xz --directory /usr/bin &>/dev/null
          - kics -q /usr/bin/assets/queries -p ${PWD} -o ${PWD}
        artifacts:
          - results.json
```
