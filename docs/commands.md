# KICS CLI

KICS is a command line tool, and should be used in a terminal. The next section describes the usage, the same help content is displayed when kics is provided with the `--help` flag.

## KICS Command

KICS has the following commands available:

```txt
Keeping Infrastructure as Code Secure

Usage:
  kics [command]

Available Commands:
  generate-id    Generates uuid for query
  help           Help about any command
  list-platforms List supported platforms
  remediate      Auto remediates the project
  scan           Executes a scan analysis
  version        Displays the current version

Flags:
      --ci                  display only log messages to CLI output (mutually exclusive with silent)
  -h, --help                help for kics
  -f, --log-format string   determines log format (pretty,json) (default "pretty")
      --log-level string    determines log level (TRACE,DEBUG,INFO,WARN,ERROR,FATAL) (default "INFO")
      --log-path string     path to generate log file (info.log)
      --no-color            disable CLI color output
      --profiling string    enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)
  -s, --silent              silence stdout messages (mutually exclusive with verbose and ci)
  -v, --verbose             write logs to stdout too (mutually exclusive with silent)

Use "kics [command] --help" for more information about a command.
```

## Scan Command Options

```txt
Executes a scan analysis

Usage:
  kics scan [flags]

Flags:
  -m, --bom                           include bill of materials (BoM) in results output
      --cloud-provider strings        list of cloud providers to scan (alicloud, aws, azure, gcp)
      --config string                 path to configuration file
      --disable-full-descriptions     disable request for full descriptions and use default vulnerability descriptions
      --disable-secrets               disable secrets scanning
      --exclude-categories strings    exclude categories by providing its name
                                      cannot be provided with query inclusion flags
                                      can be provided multiple times or as a comma separated string
                                      example: 'Access control,Best practices'
      --exclude-gitignore             disables the exclusion of paths specified within .gitignore file                                
  -e, --exclude-paths strings         exclude paths from scan
                                      supports glob and can be provided multiple times or as a quoted comma separated string
                                      example: './shouldNotScan/*,somefile.txt'
      --exclude-queries strings       exclude queries by providing the query ID
                                      cannot be provided with query inclusion flags
                                      can be provided multiple times or as a comma separated string
                                      example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'
  -x, --exclude-results strings       exclude results by providing the similarity ID of a result
                                      can be provided multiple times or as a comma separated string
                                      example: 'fec62a97d569662093dbb9739360942f...,31263s5696620s93dbb973d9360942fc2a...'
      --exclude-severities strings    exclude results by providing the severity of a result
                                      can be provided multiple times or as a comma separated string
                                      example: 'info,low'
                                      possible values: 'high, medium, low, info, trace'
      --fail-on strings               which kind of results should return an exit code different from 0
                                      accepts: high, medium, low and info
                                      example: "high,low" (default [high,medium,low,info])
  -h, --help                          help for scan
      --ignore-on-exit string         defines which kind of non-zero exits code should be ignored
                                      accepts: all, results, errors, none
                                      example: if 'results' is set, only engine errors will make KICS exit code different from 0 (default "none")
  -i, --include-queries strings       include queries by providing the query ID
                                      cannot be provided with query exclusion flags
                                      can be provided multiple times or as a comma separated string
                                      example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'
      --input-data string             path to query input data files
  -b, --libraries-path string         path to directory with libraries (default "./assets/libraries")
      --minimal-ui                    simplified version of CLI output
      --no-progress                   hides the progress bar
      --output-name string            name used on report creations (default "results")
  -o, --output-path string            directory path to store reports
  -p, --path strings                  paths or directories to scan
                                      example: "./somepath,somefile.txt"
      --payload-lines                 adds line information inside the payload when printing the payload file
  -d, --payload-path string           path to store internal representation JSON file
      --preview-lines int             number of lines to be display in CLI results (min: 1, max: 30) (default 3)
  -q, --queries-path strings          paths to directory with queries (default [./assets/queries])
      --report-formats strings        formats in which the results will be exported (all, asff, codeclimate, csv, cyclonedx, glsast, html, json, junit, pdf, sarif, sonarqube) (default [json])
  -r, --secrets-regexes-path string   path to secrets regex rules configuration file
      --timeout int                   number of seconds the query has to execute before being canceled (default 60)
  -t, --type strings                  case insensitive list of platform types to scan
                                      (Ansible, AzureResourceManager, Buildah, CloudFormation, Crossplane, DockerCompose, Dockerfile, GRPC, GoogleDeploymentManager, Knative, Kubernetes, OpenAPI, Pulumi, ServerLessFW, Terraform)
                                      cannot be provided with type exclusion flags
      --exclude-type strings          case insensitive list of platform types not to scan
                                      (Ansible, AzureResourceManager, Buildah, CloudFormation, Crossplane, DockerCompose, Dockerfile, GRPC, GoogleDeploymentManager, Knative, Kubernetes, OpenAPI, Pulumi, ServerLessFW, Terraform)
                                      cannot be provided with type inclusion flags

Global Flags:
      --ci                  display only log messages to CLI output (mutually exclusive with silent)
  -f, --log-format string   determines log format (pretty,json) (default "pretty")
      --log-level string    determines log level (TRACE,DEBUG,INFO,WARN,ERROR,FATAL) (default "INFO")
      --log-path string     path to generate log file (info.log)
      --no-color            disable CLI color output
      --profiling string    enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)
  -s, --silent              silence stdout messages (mutually exclusive with verbose and ci)
  -v, --verbose             write logs to stdout too (mutually exclusive with silent)
```

## Auto Remediate Command Options

```txt
Auto remediates the project

Usage:
  kics remediate [flags]

Flags:
  -h, --help                  help for remediate
      --include-ids strings   which remediation (similarity ids) should be remediated 
                              example "f6b7acac2d541d8c15c88d2be51b0e6abd576750b71c580f2e3a9346f7ed0e67,6af5fc5d7c0ad0077348a090f7c09949369d24d5608bbdbd14376a15de62afd1" (default [all])
      --results string        points to the JSON results file with remediation
```

The other commands have no further options.

## Exclude Paths
By default, KICS excludes paths specified in the .gitignore file in the root of the repository. To disable this behavior, use flag `--exclude-gitignore`.

## Library Flag Usage

As mentioned above, the library flag (`-b` or `--libraries-path`) refers to the directory with libraries. The functions need to be grouped by platform and the library file name should follow the format: `<platform>.rego` to be loaded by KICS. It doesn't matter your directory structure. In other words, for example, if you want to indicate a directory that contains a library for your terraform queries, you should group your functions (used in your terraform queries) in a file named `terraform.rego` wherever you want.

This will merge the custom libraries found on the flag's path with KICS's default libraries. Note that any functions declared in a custom library with the same signature as an existing function in the [default libraries](https://github.com/Checkmarx/kics/tree/master/assets/libraries) will cause **the default library function to be overwritten by the custom definition provided**.

---

## Profiling

With the `--profiling` flag KICS will print resource consumption information in the logs.

You can only enable one profiler at a time, CPU or MEM.

📝 Please note that execution time may be impacted by enabling performance profiler due to sampling

## Disable Crash Report

You can disable KICS crash report to [sentry.io](https://sentry.io) with `DISABLE_CRASH_REPORT` environment variable set to `0` or `false` e.g:

```sh
DISABLE_CRASH_REPORT=0 ./bin/kics version
# 'KICS crash report disabled' message should appear in the logs
```
