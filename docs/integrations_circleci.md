# Running KICS in CircleCI

You can integrate KICS into your CircleCI workflows.

This document provides you with an example on how to run KICS scans in a pipeline.

## Example setup with GitHub:

Enable CircleCI to access your personal profile or GitHub organization.

Create a `.circleci` directory in your project's root and place a `config.yaml` inside:

```yaml
version: 2.1
jobs:
  kics:
    docker:
      - image: checkmarx/kics:latest
    steps:
      - checkout
      - run:
          name: Run KICS
          command: |
            /app/bin/kics scan -p ${PWD} -o ${PWD} --ci
      - store_artifacts:
          path: ${PWD}/results.json

workflows:
  version: 2
  build:
    jobs:
      # etc...
      - kics

```

After running a pipeline, you will be able to see "Run KICS" step inside workflow's details:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/circleci-build.png" width="850">

Go to the artifacts tab to inspect the results:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/circleci-artifacts.png" width="850">

Results will be displayed in plain text:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/0f82e84ccbab376b4606efe5a85432d5b37ecb19/docs/img/circleci-results.png" width="850">
