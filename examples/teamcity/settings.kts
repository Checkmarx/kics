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


