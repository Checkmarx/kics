## Integrate KICS with GitLab CI

You can integrate KICS into your GitLab CI/CD pipelines.

This provides you the ability to run KICS scans in your GitLab repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

### Including Template

You can integrate KICS into your pipeline by [including](https://docs.gitlab.com/ee/ci/yaml/includes.html) our [versioned](https://docs.gitlab.com/ee/development/cicd/templates.html#versioning) [template](https://raw.githubusercontent.com/checkmarx/kics/master/examples/gitlab/KICS.v1.gitlabci.yaml) in your `gitlabci.yaml`:

```yaml
include:
  - remote: https://raw.githubusercontent.com/checkmarx/kics/master/examples/gitlab/KICS.v1.gitlabci.yaml
```

### Full Example

```yaml
image: alpine

before_script:
  - apk add --no-cache libc6-compat curl
  - DATETIME="`date '+%H:%M'`"
  - TAG=`curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
  - echo "${DATETIME} - INF latest tag is $TAG"
  - VERSION=`echo $TAG | sed -r 's/^.{1}//'`
  - echo "${DATETIME} - INF version is $VERSION"
  - echo "${DATETIME} - INF downloading latest kics binaries kics_${VERSION}_linux_x64.tar.gz"
  - wget -q -c "https://github.com/Checkmarx/kics/releases/download/${TAG}/kics_${VERSION}_linux_x64.tar.gz" -O - | tar -xz --directory /usr/bin &>/dev/null

stages:
  - kics
  - kics-result

kics-scan:
  stage: kics
  script:
    - kics scan -q /usr/bin/assets/queries -p ${PWD} -o ${PWD}/kics-results.json
  artifacts:
    name: kics-results.json
    paths:
      - kics-results.json

kics-results:
  stage: kics-result
  before_script:
    - export TOTAL_SEVERITY_COUNTER=`grep '"total_counter"':' ' kics-results.json | awk {'print $2'}`
    - export SEVERITY_COUNTER_HIGH=`grep '"HIGH"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
    - export SEVERITY_COUNTER_MEDIUM=`grep '"INFO"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
    - export SEVERITY_COUNTER_LOW=`grep '"LOW"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
    - export SEVERITY_COUNTER_INFO=`grep '"MEDIUM"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
  script:
    - |
      echo "TOTAL SEVERITY COUNTER: $TOTAL_SEVERITY_COUNTER
      SEVERITY COUNTER HIGH: $SEVERITY_COUNTER_HIGH
      SEVERITY COUNTER MEDIUM: $SEVERITY_COUNTER_MEDIUM
      SEVERITY COUNTER LOW: $SEVERITY_COUNTER_LOW
      SEVERITY COUNTER INFO: $SEVERITY_COUNTER_INFO"
    - if [ "$SEVERITY_COUNTER_HIGH" -ge "1" ];then echo "Please fix all $SEVERITY_COUNTER_HIGH HIGH SEVERITY ISSUES" && exit 1;fi
```

---

### Example Results
When your pipeline executes, it will run this job. If KICS finds any issues, it will fail the build.

#### Pipeline Failure

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_pipeline_failure.png" width="850">


#### Pipeline Success

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_pipeline_success.png" width="850">

#### Download Artifact

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_gitlab_pipeline_artifact.png" width="850">
