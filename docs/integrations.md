## Integrations Overview

### Plugins

You can integrate KICS with your favorite CI/CD pipelines.
We provide plugins for some CI/CD tools. For some others we provide a tutorial on how the integration can be done.

Integrate KICS with:

- [Azure Pipelines](integrations_azurepipelines.md)
- [Bitbucket Pipelines](integrations_bitbucketpipelines.md)
- [CircleCI](integrations_circleci.md)
- [Github Actions](integrations_ghactions.md)
- [GitLab CI](integrations_gitlabci.md)
- [Jenkins](integrations_jenkins.md)
- [TeamCity](integrations_teamcity.md)
- [Travis](integrations_travisci.md)
- More soon...

The pipelines examples can be found in our [GitHub Repository](https://github.com/Checkmarx/kics/tree/master/examples)

### MegaLinter

KICS is natively embedded in [MegaLinter](https://megalinter.github.io/), a 100% Open-Source tool for CI/CD workflows that analyzes consistency and quality of:

- 48 languages
- 22 formats
- 20 tooling formats 
- excessive copy-pastes and spelling mistakes 
 
It also generates various reports, and can apply formatting and auto-fixes, to ensure all your projects sources are clean, whatever IDE/toolbox are used by their developers.

To install MegaLinter in your repository, just run the following command

`npx mega-linter-runner --install`
