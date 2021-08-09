# Running KICS in Jenkins

You can integrate KICS into your Jenkins CI/CD pipelines.

This provides you the ability to run KICS scans as a stage in your pipeline.

## Declarative pipelines:

Create a new pipeline clicking on **New Item** on the left menu bar, then fill in the name of your pipeline and select the option "pipeline":

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-creating-pipeline.png" width="850">

Paste one of the pipeline examples bellow:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-paste-pipeline.png" width="850">

Save and run your pipeline.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-pipeline-success.png" width="850">

Click on the build number to download the reports stored as artifacts.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-pipeline-artifacts.png" width="850">

### Install and run

The following pipeline uses downloads KICS binaries and place them under `/usr/bin/kics` before scanning a project:

```groovy
pipeline {
  agent any
  stages {
    stage('Checkout Code') {
      steps {
        git(branch: 'master', url: 'https://github.com/GoogleCloudPlatform/terraform-google-examples')
      }
    }
    // Other stages ...
    stage('KICS scan') {
      steps {
        installKICS()
        sh "mkdir -p results"
        sh(script: '/usr/bin/kics scan --ci --no-color -p ${WORKSPACE} --output-path results --report-formats "json,sarif,html"')
        archiveArtifacts(artifacts: 'results/*.html,results/*.sarif,results/*.json', fingerprint: true)
      }
    }
  }
}

def installKICS(){
  def installScript = '''
    LATEST_VERSION=1.2.4
    if ! command -v /usr/bin/kics; then
      wget -q -c https://github.com/Checkmarx/kics/releases/download/v${LATEST_VERSION}/kics_${LATEST_VERSION}_Linux_x64.tar.gz -O /tmp/kics.tar.gz
      tar xfzv /tmp/kics.tar.gz -C /usr/bin
      rm -f kics.tar.gz
    fi
    /usr/bin/kics version
  '''

  sh(script: installScript)
}
```

### Using Docker

The following pipeline uses KICS docker image to scan a project and publishes the HTML report in Jenkins.

Plugins required:
- [HTML Publisher Plugin](https://plugins.jenkins.io/htmlpublisher/)
- [Docker Plugin](https://plugins.jenkins.io/docker-plugin/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)

```groovy
pipeline {
    agent {
        docker {
            image 'ubuntu:latest'
        }
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
        disableConcurrentBuilds()
    }
    stages {
        stage('Checkout Code') {
          steps {
              git branch: 'master', url: 'https://github.com/GoogleCloudPlatform/terraform-google-examples'
              stash includes: '**/*', name: 'source'
          }
        }
        stage('KICS scan') {
            steps {
                script {
                    docker.image('checkmarx/kics:latest-alpine').inside("--entrypoint=''") {
                      unstash 'source'
                      sh('/app/bin/kics scan -p \$(pwd) -q /app/bin/assets/queries --ci --report-formats html -o \$(pwd)')
                      archiveArtifacts(artifacts: 'results.html', fingerprint: true)
                      publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '.', reportFiles: 'results.html', reportName: 'KICS Results', reportTitles: ''])
                    }
                }
            }
        }
    }
}
```

The report will be published in pure HTML by default, if you want to enable your browser to load css and javascript embedded in the report.html you'll have to configure a custom Content-Security-Policy HTTP header.

| 📝 &nbsp; WARNING                                                    |
|:---------------------------------------------------------------------|
| Only disable Jenkins security features if you know what you're doing |

</br>

Go to **Manage Jenkins** > **Script Console**

Paste the following script and run:

```groovy
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "sandbox allow-scripts; default-src *; style-src * http://* 'unsafe-inline' 'unsafe-eval'; script-src 'self' http://* 'unsafe-inline' 'unsafe-eval'");
```

Jenkins will exhibit the following warning:

```
The default Content-Security-Policy is currently overridden using the hudson.model.DirectoryBrowserSupport.CSP system property, which is a potential security issue when browsing untrusted files. As an alternative, you can set up a resource root URL that Jenkins will use to serve some static files without adding Content-Security-Policy headers.
```

