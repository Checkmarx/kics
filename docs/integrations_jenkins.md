# Running KICS in Jenkins

You can integrate KICS into your Jenkins CI/CD pipelines.

This provides you the ability to run KICS scans as a stage in your pipeline.

## Declarative pipelines:

Create a new pipeline by clicking on **New Item** on the left menu bar, then fill in the name of your pipeline and select the option "pipeline":

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-creating-pipeline.png" width="850">

Paste one of the pipeline examples below:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-paste-pipeline.png" width="850">

Save and run your pipeline.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-pipeline-success.png" width="850">

Click on the build number to download the reports stored as artifacts.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-pipeline-artifacts.png" width="850">

### Using Docker

The following pipeline uses the KICS docker image to scan a project and publishes the HTML report in Jenkins.

Plugins required:

-   [HTML Publisher Plugin](https://plugins.jenkins.io/htmlpublisher/)
-   [Docker Plugin](https://plugins.jenkins.io/docker-plugin/)
-   [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)

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
                    docker.image('checkmarx/kics:latest').inside("--entrypoint=''") {
                      unstash 'source'
                      sh('/app/bin/kics scan -p \'\$(pwd)\' --ci --report-formats html -o \'\$(pwd)\' --ignore-on-exit results')
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
| :------------------------------------------------------------------- |
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

### Using KICS with JUnit plugin

First of all you need to check if the JUnit plugin is installed:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-junit-plugin.png" width="850">

If it is not installed, you can install it by clicking on **Plugins** on the left menu bar, then click on **Install Plugin** and select **JUnit**.

After that, you can add the following line to your pipeline script:

```groovy
    junit testResults: 'results/junit-results.xml', skipPublishingChecks: true
```

The skipPublishingChecks option is important, otherwise the JUnit plugin will try to publish the results to GitHub in Jenkins. If you want to do this, you should check the [JUnit plugin documentation](https://plugins.jenkins.io/junit/) for more information.

If you are using our example script, it will look like the following:

```groovy
pipeline {
  agent any
  stages {
    stage('Checkout Code') {
      steps {
        git(branch: 'master', url: 'https://github.com/GoogleCloudPlatform/terraform-google-examples')
      }
    }

    stage('KICS scan') {
      steps {
        sh "mkdir -p results"
        sh(script: '/usr/bin/kics scan --ci --no-color -p ${WORKSPACE} --output-path results --ignore-on-exit results --report-formats "json,sarif,html"')
        junit testResults: 'results/junit-results.xml', skipPublishingChecks: true
        archiveArtifacts(artifacts: 'results/*.html,results/*.sarif,results/*.json', fingerprint: true)
      }
    }
  }
}
```

This will publish the JUnit results in Jenkins as you can see in the next images:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-junit-overview.png" width="850">

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-junit-results-overview.png" width="850">

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/jenkins-junit-result-details.png" width="850">
