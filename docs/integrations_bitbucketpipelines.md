## Integrate KICS with Bitbucket Pipelines

You can integrate KICS into Bitbucket Pipelines CI/CD.

This provides you the ability to run KICS scans in your Bitbucket repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

### Example configuration

```yaml
image: checkmarx/kics:latest

pipelines:
    default:
        - step:
              name: "Cx KICS"
              script:
                  - kics scan --ignore-on-exit results -p ${PWD} -o ${PWD}
              artifacts:
                  - results.json
```

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics-scan-bitbucket-pipelines.png" width="850">
