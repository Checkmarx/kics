## Integrate KICS with Bitbucket Pipelines

You can integrate KICS into Bitbucket Pipelines CI/CD.

This provides you the ability to run KICS scans in your Bitbucket repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

### Example configuration

```yaml
image: atlassian/default-image:2

pipelines:
  default:
    - step:
        name: 'Cx KICS'
        script:
          - LATEST_KICS_TAG=$(curl --silent "https://api.github.com/repos/Checkmarx/kics/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
          - LATEST_KICS_VERSION=${LATEST_KICS_TAG#v}
          - wget -q -c "https://github.com/Checkmarx/kics/releases/download/${LATEST_KICS_TAG}/kics_${LATEST_KICS_VERSION}_linux_x64.tar.gz" -O - | tar -xz --directory /usr/bin &>/dev/null
          - kics -q /usr/bin/assets/queries -p ${PWD} -o ${PWD}/kics-results.json
          - TOTAL_SEVERITY_COUNTER=`grep '"totalCounter"':' ' ${PWD}/kics-results.json | awk {'print $2'}`
          - export SEVERITY_COUNTER_HIGH=`grep '"HIGH"':' ' ${PWD}/kics-results.json | awk {'print $2'} | sed 's/.$//'`
          - SEVERITY_COUNTER_MEDIUM=`grep '"INFO"':' ' ${PWD}/kics-results.json | awk {'print $2'} | sed 's/.$//'`
          - SEVERITY_COUNTER_LOW=`grep '"LOW"':' ' ${PWD}/kics-results.json | awk {'print $2'} | sed 's/.$//'`
          - SEVERITY_COUNTER_INFO=`grep '"MEDIUM"':' ' ${PWD}/kics-results.json | awk {'print $2'} | sed 's/.$//'`
          - echo "TOTAL SEVERITY COUNTER $TOTAL_SEVERITY_COUNTER"
          - if [ "$SEVERITY_COUNTER_HIGH" -ge "1" ];then echo "Please fix all $SEVERITY_COUNTER_HIGH HIGH SEVERITY COUNTERS" && exit 1;fi
        artifacts:
          - kics-results.json

```
