## Integrate KICS with GitLab CI

You can integrate KICS into your GitLab CI/CD pipelines.

This provides you the ability to run KICS scans in your GitLab repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

<!-- ### Including Template

You can integrate KICS into your pipeline by [including](https://docs.gitlab.com/ee/ci/yaml/includes.html) our [versioned](https://docs.gitlab.com/ee/development/cicd/templates.html#versioning) [template](https://raw.githubusercontent.com/checkmarx/kics/master/examples/gitlab/KICS.v1.gitlabci.yaml) in your `gitlabci.yaml`: -->

<!-- ```yaml
include:
    - remote: https://raw.githubusercontent.com/checkmarx/kics/master/examples/gitlab/KICS.v1.gitlabci.yaml
``` -->

### Full Example

```yaml
image:
    name: checkmarx/kics:latest
    entrypoint: [""]

stages:
    - kics

kics-scan:
    stage: kics
    script:
        - kics scan --no-progress -p ${PWD} -o ${PWD} --report-formats json --output-name kics-results
    artifacts:
        name: kics-results.json
        paths:
            - kics-results.json
        when: always
```

---

### Example Results

When your pipeline executes, it will run this job. If KICS finds any issues, it will fail the build.

#### Pipeline Failure

<img src="https://raw.githubusercontent.com/Checkmarx/kics/fb3d0d28a14d79040e9368418016788bdd155017/docs/img/kics_gitlab_pipeline_failure.png" width="850">

#### Pipeline Success

<img src="https://raw.githubusercontent.com/Checkmarx/kics/fb3d0d28a14d79040e9368418016788bdd155017/docs/img/kics_gitlab_pipeline_success.png" width="850">

#### Download Artifact

<img src="https://raw.githubusercontent.com/Checkmarx/kics/f2cd57f929424ee60765622d8b1a3f784707a58f/docs/img/kics_gitlab_pipeline_artifact.png" width="850">

## Using GitLab SAST Reports

```yaml
image:
    name: checkmarx/kics:latest
    entrypoint: [""]

stages:
    - kics

kics-scan:
    stage: kics
    script:
        - kics scan -p ${PWD} --ignore-on-exit all --report-formats glsast -o ${PWD} --output-name kics-results
    artifacts:
        reports:
            sast: gl-sast-kics-results.json
        when: always
```

### Example results

#### Pipeline SAST report integration

<br>

> 📝 &nbsp; This feature requires [Gitlab Ultimate](https://docs.gitlab.com/ee/user/application_security/sast/#summary-of-features-per-tier).

<br>

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_pipeline_sast_report.png" width="850">

<br>

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_pipeline_sast_report_result.png" width="850">

## Code Quality integration

It is possible to get code quality report with Kics scan, see the example:

```yaml
image:
    name: checkmarx/kics:latest
    entrypoint: [""]

stages:
    - test

code_quality:
    stage: test
    script:
        - kics scan --no-progress -p ${PWD} -o ${PWD} --report-formats codeclimate --output-name codeclimate-result
    artifacts:
        paths:
            - codeclimate-result.json
        reports:
            codequality: codeclimate-result.json
```

### Code Quality Report

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_code_quality_report.png" width="850">
