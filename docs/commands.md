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
      --cloud-provider strings       list of cloud providers to scan (aws, azure, gcp)
      --config string                path to configuration file
      --exclude-categories strings   exclude categories by providing its name
                                     cannot be provided with query inclusion flags
                                     can be provided multiple times or as a comma separated string
                                     example: 'Access control,Best practices'
  -e, --exclude-paths strings        exclude paths from scan
                                     supports glob and can be provided multiple times or as a quoted comma separated string
                                     example: './shouldNotScan/*,somefile.txt'
      --exclude-queries strings      exclude queries by providing the query ID
                                     cannot be provided with query inclusion flags
                                     can be provided multiple times or as a comma separated string
                                     example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'
  -x, --exclude-results strings      exclude results by providing the similarity ID of a result
                                     can be provided multiple times or as a comma separated string
      --exclude-severities strings   exclude results by providing the severity of a result
                                     can be provided multiple times or as a comma separated string
                                     example: 'info,low'
                                     example: 'fec62a97d569662093dbb9739360942f...,31263s5696620s93dbb973d9360942fc2a...'
      --fail-on strings              which kind of results should return an exit code different from 0
                                     accepts: high, medium, low and info
                                     example: "high,low" (default [high,medium,low,info])
  -h, --help                         help for scan
      --ignore-on-exit string        defines which kind of non-zero exits code should be ignored
                                     accepts: all, results, errors, none
                                     example: if 'results' is set, only engine errors will make KICS exit code different from 0 (default "none")
  -i, --include-queries strings      include queries by providing the query ID
                                     cannot be provided with query exclusion flags
                                     can be provided multiple times or as a comma separated string
                                     example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'
      --input-data string            path to query input data files
  -b, --library string               path to directory with libraries (default "./assets/libraries")
      --minimal-ui                   simplified version of CLI output
      --no-progress                  hides the progress bar
      --disable-full-descriptions    disable request for full descriptions and use default vulnerability descriptions
      --output-name string           name used on report creations (default "results")
  -o, --output-path string           directory path to store reports
  -p, --path strings                 paths or directories to scan
                                     example: "./somepath,somefile.txt"
  -d, --payload-path string          path to store internal representation JSON file
      --preview-lines int            number of lines to be display in CLI results (min: 1, max: 30) (default 3)
  -q, --queries-path string          path to directory with queries (default "./assets/queries")
      --report-formats strings       formats in which the results will be exported (all, glsast, html, json, pdf, sarif) (default [json])
      --timeout int                  number of seconds the query has to execute before being canceled (default 60)
  -t, --type strings                 case insensitive list of platform types to scan
                                     (Ansible, AzureResourceManager, CloudFormation, Dockerfile, Kubernetes, OpenAPI, Terraform)

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

The other commands have no further options.

## Library Flag Usage

As mentioned above, the library flag (`-b`) refers to the directory with libraries. The functions need to be grouped by platform and the library file name should follow the format: `<platform>.rego` to be loaded by KICS. It doesn't matter your directory structure. In other words, for example, if you want to indicate a directory that contains a library for your terraform queries, you should group your functions (used in your terraform queries) in a file named `terraform.rego` wherever you want.


---

## Profiling

With the `--profiling` flag KICS will print resource consumption information in the logs.

You can only enable one profiler at a time, CPU or MEM.

📝   Please note that execution time may be impacted by enabling performance profiler due to sampling

## Disable Crash Report

You can disable KICS crash report to [sentry.io](https://sentry.io) with `DISABLE_CRASH_REPORT` environment variable set to `0` or `false` e.g:

```sh
DISABLE_CRASH_REPORT=0 ./bin/kics version
# 'KICS crash report disabled' message should appear in the logs
```
