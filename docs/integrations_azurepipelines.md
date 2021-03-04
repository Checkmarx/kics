## Integrate KICS with Azure Pipelines

You can integrate KICS into your Azure Pipelines CI/CD.

This provides you the ability to run KICS scans in your GitLab repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).


### Tutorial

The following tutorial is a possible way of using KICS in Azure Pipelines CI. You can be creative and come up with different solutions that fit your pipelines.

In this case we instruct the job to download and use the latest Linux version of KICS.

1- Edit or add a new azure-pipelines.yml file in the root of your repository

2- Declare a new stage
```yaml
stages:
- stage: Kics
  displayName: Kics
```

3- Declare the steps - in this case it is a script where we follow the steps:

3.1- Get the OS name: ` OS=$(uname -s)`

3.2- Declare version and KICS binaries to download
```shell
get_latest_kics_release() {
    curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" |
        grep '"tag_name":' |
        sed -E 's/.*"([^"]+)".*/\1/'
}
LATEST_TAG=$(get_latest_kics_release)
LATEST_VERSION=${LATEST_TAG#v}
PACKAGE_NAME=kics_${LATEST_VERSION}_${OS}_x64.tar.gz
TARGET_DIR=/home/vsts/kics
```

3.3- Download the binary
```shell
mkdir -p ${TARGET_DIR}
wget -q -c https://github.com/Checkmarx/kics/releases/download/${LATEST_TAG}/${PACKAGE_NAME} -O - | tar -xz -C ${TARGET_DIR}
```

3.4- Start the scan
```shell
 ${TARGET_DIR}/kics --no-progress -q ${TARGET_DIR}/assets/queries -p ${PWD} -o ${PWD}/kics-results.json
```

3.5- Consume the results
```shell
TOTAL_SEVERITY_COUNTER=`grep '"total_counter"':' ' kics-results.json | awk {'print $2'}`
export SEVERITY_COUNTER_HIGH=`grep '"HIGH"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
SEVERITY_COUNTER_MEDIUM=`grep '"INFO"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
SEVERITY_COUNTER_LOW=`grep '"LOW"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
SEVERITY_COUNTER_INFO=`grep '"MEDIUM"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
echo "TOTAL SEVERITY COUNTER $TOTAL_SEVERITY_COUNTER"
```

3.6- Optionally, define a breaking point for the CI
```shell
if [ "$SEVERITY_COUNTER_HIGH" -ge "1" ]; then
    echo "Please fix all $SEVERITY_COUNTER_HIGH HIGH SEVERITY COUNTERS" && exit 1;
fi
```

---

Here is the full content of the job

```yaml
trigger:
- master

pool:
  vmImage: 'ubuntu-latest'

stages:
- stage: Kics
  displayName: Kics

  jobs:
  - job: runKics
    displayName: runKics
    steps:
      - script: |
          get_latest_kics_release() {
            curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" |
              grep '"tag_name":' |
              sed -E 's/.*"([^"]+)".*/\1/'
          }

          OS=$(uname -s)
          LATEST_TAG=$(get_latest_kics_release)
          LATEST_VERSION=${LATEST_TAG#v}
          PACKAGE_NAME=kics_${LATEST_VERSION}_${OS}_x64.tar.gz
          TARGET_DIR=/home/vsts/kics

          mkdir -p ${TARGET_DIR}
          wget -q -c https://github.com/Checkmarx/kics/releases/download/${LATEST_TAG}/${PACKAGE_NAME} -O - | tar -xz -C ${TARGET_DIR}

          echo '--- START SCANNING ---'
          ${TARGET_DIR}/kics --no-progress -q ${TARGET_DIR}/assets/queries -p ${PWD} -o ${PWD}/kics-results.json

          TOTAL_SEVERITY_COUNTER=`grep '"total_counter"':' ' kics-results.json | awk {'print $2'}`
          export SEVERITY_COUNTER_HIGH=`grep '"HIGH"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
          SEVERITY_COUNTER_MEDIUM=`grep '"INFO"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
          SEVERITY_COUNTER_LOW=`grep '"LOW"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
          SEVERITY_COUNTER_INFO=`grep '"MEDIUM"':' ' kics-results.json | awk {'print $2'} | sed 's/.$//'`
          echo "TOTAL SEVERITY COUNTER $TOTAL_SEVERITY_COUNTER"

          if [ "$SEVERITY_COUNTER_HIGH" -ge "1" ]; then
            echo "Please fix all $SEVERITY_COUNTER_HIGH HIGH SEVERITY COUNTERS" && exit 1;
          fi
```

---

### Example Results
When your pipeline executes, it will run this job. If KICS finds any issues, it will fail the build.

#### Pipeline Failure
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_azure_pipelines_failure.png" width="850">

#### Pipeline Success
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_azure_pipelines_success.png" width="850">
