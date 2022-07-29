# Running KICS on AWS CodeBuild

You can integrate KICS into your AWS CodeBuild workflows.

This provides you the ability to run KICS scans to find vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

## Example setup with GitHub

Enable AWS CodeBuild to access your personal profile or GitHub organization.

Create a `buildspec.yml` file on the root of your repository, for example:

```yaml
version: 0.2

phases:
    build:
        commands:
            - echo Starting Kics scan
            - docker run -v $PWD:/path checkmarx/kics scan --no-progress --ignore-on-exit all -p /path -o /path --report-formats junit --output-name kics-report
reports:
    kics-report:
        files:
            - junit-kics-report.xml
```

After running the pipeline, you can see the logs and the reports section:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/codebuild-report.png" width="850">

Go to report section to see reports:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/codebuild-report-section.png" width="850">

Select the desired report to see the test cases:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/codebuild-test-cases.png" width="850">
