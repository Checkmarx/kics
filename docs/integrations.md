## Integrations

Integrate your CI with Github Actions, GitLab CI/CD. 

## Integrate KICS with Github Actions

You can integrate KICS into your Github Actions. 
This provides you the ability to integrate KICS scans and apply KICS vulnerabilities and miconfiguration checks to your infrastructure as code (IaC)

Use KICS GitHub action from the [marketplace](https://github.com/marketplace/actions/kics-github-action)

and read about GitHub actions integration in the official GitHub [documentation](https://docs.github.com/en/free-pro-team@latest/actions/quickstart)

Here you can see it in action ;)

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_scan_github_actions.png" width="850">  

Visit the [KICS GitHub Action project](https://github.com/marketplace/actions/kics-github-action) to get more details

and take a look at the [example usage](https://github.com/marketplace/actions/kics-github-action#example-usage) shown above

## Integrate KICS with GitLab CI

You can integrate KICS into your GitLab CI/CD. 
This provides you the ability to integrate KICS scans and apply KICS vulnerabilities and miconfiguration checks to your infrastructure as code (IaC)

### Basic Setup

Add a new job in the .gitlab-ci.yml file in your repository.

Here is a simple example:

```
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
    - export TOTAL_SEVERITY_COUNTER=`grep '"totalCounter"':' ' kics-results.json | awk {'print $2'}`
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

### Example Results
When your pipeline executes, it will run this jobs. If KICS finds any issues, it will fail the build.

#### Pipeline Failure

<img src="https://raw.githubusercontent.com/Checkmarx/kics/feature/add_gitlab_integration/docs/img/kics_gitlab_pipeline_success.png" width="850">

#### Pipeline Success

<img src="https://raw.githubusercontent.com/Checkmarx/kics/feature/add_gitlab_integration/docs/img/kics_scan_github_actions.png" width="850">

### Download Artifact

<img src="https://raw.githubusercontent.com/Checkmarx/kics/feature/add_gitlab_integration/docs/img/kics_gitlab_pipeline_artifact.png" width="850">