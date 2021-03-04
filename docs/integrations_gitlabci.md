## Integrate KICS with GitLab CI

You can integrate KICS into your GitLab CI/CD pipelines.

This provides you the ability to run KICS scans in your GitLab repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).


### Tutorial

The following tutorial is a possible way of using KICS in GitLab CI. You can be creative and come up with different solutions that fit your pipelines.

In this case we instruct the job to download and use the latest Linux version of KICS.

1- Edit or add a new job in the .gitlab-ci.yml file in your repository.

2- In the beginning of the job, instruct it to get the latest version of KICS, for example in `before_script`:
```yaml
before_script:
  - apk add --no-cache libc6-compat curl
  - TAG=`curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
  - VERSION=`echo $TAG | sed -r 's/^.{1}//'`
  - wget -q -c "https://github.com/Checkmarx/kics/releases/download/${TAG}/kics_${VERSION}_linux_x64.tar.gz" -O - | tar -xz --directory /usr/bin &>/dev/null
```

3- Define the necessary stages. For instance, scan with KICS and consume the results
```yaml
stages:
  - kics
  - kics-result
```

4- Declare the KICS scan
```yaml
kics-scan:
  stage: kics
  script:
    - kics scan -q /usr/bin/assets/queries -p ${PWD} -o ${PWD}/kics-results.json
  artifacts:
    name: kics-results.json
    paths:
      - kics-results.json
```

5- Declare the consumption of results
```yaml
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
Notice the last line, where it is defined a failing CI condition in case there is at least 1 High Severity result.

---

Here is the full example:

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
