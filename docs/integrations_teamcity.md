# Running KICS in TeamCity

You can integrate KICS into TeamCity pipelines easily by [Kotlin DSL](https://www.jetbrains.com/help/teamcity/2021.2/kotlin-dsl.html) and KICS docker image.

This provide you the ability to run KICS scans as a stage of your pipeline.

Just make sure that the [TeamCity agent](https://www.jetbrains.com/help/teamcity/2021.2/setting-up-and-running-additional-build-agents.html) has Docker configured to run containers.

Checkout [Getting Started with Kotlin DSL](https://www.jetbrains.com/help/teamcity/2021.2/kotlin-dsl.html#Getting+Started+with+Kotlin+DSL) and modify you `.teamcity/settings.kts` as the example:

```kotlin
import jetbrains.buildServer.configs.kotlin.v2019_2.*
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.script
version = "2021.1"

project {
    description = "KICS TeamCity integration test"
    buildType(Build)
}

object Build: BuildType({
    name = "KICS TeamCity integration test"
    vcs {
        root(DslContext.settingsRoot)
    }

    steps {
        script {
            scriptContent = """
                #!/bin/bash
                docker run -v ${'$'}PWD:/path checkmarx/kics:latest scan -p /path -o /path --no-progress --ignore-on-exit results
            """.trimIndent()
        }
    }
})
```

With [versioned settings](https://www.jetbrains.com/help/teamcity/2021.2/storing-project-settings-in-version-control.html#SynchronizingSettingswithVCS) enabled, after pushing the changes to the repository you'll be able to see the build progress, logs and success status.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/teamcity-scan-logs.png" width="850">

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/teamcity-success-status.png" width="850">
