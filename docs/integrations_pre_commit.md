# Running Kics with pre-commmit

To use `kics` with [pre-commit](https://pre-commit.com) add the following hook to your local repo's `.pre-commit-config.yaml` file.

```yaml
- repo: https://github.com/Checkmarx/kics
  rev: "" # change to correct tag or sha
  hooks:
      - id: kics-scan
```

## How to pass extra arguments

You can provide arguments to `kics` by providing the pre-commit `args` [property](https://pre-commit.com/#passing-arguments-to-hooks). The following example will print the `kics scan` output, but will not block regardless of success/failure.

```yaml
repos:
    - repo: https://github.com/Checkmarx/kics
      rev: "" # change to correct tag or sha
      hooks:
          - id: kics-scan
            verbose: true
            args: [--ignore-on-exit, "all"]
```

## Create your own local pre-commit hook

You can create your own local pre-commit hook using the [docker_image](https://pre-commit.com/#docker_image) language.
This is a more lightweight way to configure `kics` as a pre-commit hook.

```yaml
repos:
    - repo: local
      hooks:
          - id: kics-scan-local
            name: Kics scan
            language: docker_image
            entry: checkmarx/kics scan -p /src --no-progress
            verbose: true
```
