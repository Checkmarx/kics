## Integrate KICS with Azure Pipelines

You can integrate KICS into your Azure Pipelines CI/CD.

This provides you the ability to run KICS scans in your Azure DevOps repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

```yaml
#
# Example using JSON format
#
trigger:
  - master
pool:
  vmImage: "ubuntu-latest"
container: checkmarx/kics:debian
steps:
  # running in CI mode, exporting results to a JSON file and printing the results in stdout
  # KICS should fail the pipeline if results are found
  - script: |
      /app/bin/kics scan --ci -p ${PWD} -o ${PWD}
      cat results.json
```

---

### Example Results
When your pipeline executes, it will run this job. If KICS finds any issues, it will fail the build.

#### Pipeline Failure
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_azure_pipelines_failure.png" width="850">

#### Pipeline Success
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_azure_pipelines_success.png" width="850">


## View SARIF report in Azure DevOps pipelines

It's also possible to view KICS results by publishing the SARIF report as a build artifact and installing the [SARIF Azure DevOps Extension](https://github.com/Microsoft/sarif-azuredevops-extension)

1. Search for the *SARIF Azure DevOps Extension* in the [extensions marketplace](https://docs.microsoft.com/en-us/azure/devops/marketplace/install-extension?view=azure-devops&tabs=browser).
2. Install and give permissions to the plugin.
3. Create a pipeline to scan IaC with KICS, configure the results output in the SARIF format, and publish it as a build artifact with artifact named as `CodeAnalysisLogs`:

```yaml
#
# Example using SARIF viewer:
# https://marketplace.visualstudio.com/items?itemName=sariftools.sarif-viewer-build-tab
#
trigger:
  - master
pool:
  vmImage: "ubuntu-latest"
container: checkmarx/kics:debian
steps:
  # run in CI mode, do not fail the pipeline on results found and export the report in both json and SARIF format.
  - script: |
      /app/bin/kics scan --ci -p ${PWD} -o ${PWD} --report-formats json,sarif --ignore-on-exit results
      cat results.json
  # scan results should be visible in the SARIF viewer tab of the build.
  - task: PublishBuildArtifacts@1
    inputs:
      pathToPublish: $(System.DefaultWorkingDirectory)/results.sarif
      artifactName: CodeAnalysisLogs
```

## Build status

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/azure-devops-build-status.png" width="850">

## SARIF report inside Azure Pipelines

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/azure-devops-sarif-plugin.png" width="850">
