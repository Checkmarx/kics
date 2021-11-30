# Running Kics with pre-commmit

To use `kics` with [pre-commit](https://pre-commit.com) add the following hook to your local repo's `.pre-commit-config.yaml` file. 

```yaml
- repo: https://github.com/Checkmarx/kics
  rev: '' # change to correct tag or sha
  hooks:
    - id: kics
```

## How to pass extra arguments

You can provide arguments to `kics` by providing the pre-commit `args` [property](https://pre-commit.com/#passing-arguments-to-hooks). The following example will print the `kics scan` output, but will not block regardless of success/failure.

```yaml
repos:
- repo: https://github.com/Checkmarx/kics
  rev: '' # change to correct tag or sha
  hooks:
  - id: kics
    verbose: true
    args: [--ignore-on-exit, 'all']
```
