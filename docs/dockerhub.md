## Documentation

Visit us

[https://docs.kics.io](https://docs.kics.io)

## Git Repo

https://github.com/Checkmarx/kics

## Command

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see the full list of CLI options below)

NOTE: from v1.3.0 KICS does not execute `scan` command by default anymore.


```sh
docker pull checkmarx/kics:latest
```

Scan a directory
```sh
docker run -v {path_to_host_folder_to_scan}:/path checkmarx/kics:latest scan -p "/path" -o "/path/"
```
Scan a single file
```sh
docker run -v {path_to_host_folder}/{filename}.{extention}:/path/{filename}.{extention} checkmarx/kics:latest scan -p "/path" -o "/path/"
```

This will generate a `results.json` file, for both examples, under `path`.

ℹ️  **UBI Based Images**

When using [UBI7](https://catalog.redhat.com) based image, the KICS process will run under the `kics` user and `kics` group with default UID=1000 and GID=1000, when using bind mount to share host files with the container, the UID and GID can be overriden to match current user with the `-u` flag that overrides the username:group or UID:GID. e.g:

```sh
docker run -it -u $UID:$GID -v $PWD:/path checkmarx/kics:ubi7 scan -p /path/assets/queries/dockerfile -o /path -v
```

Another option is [rebuilding the dockerfile](https://github.com/Checkmarx/kics/blob/master/Dockerfile.ubi7) providing build arguments e.g: `--build-arg UID=999 --build-arg GID=999 --build-arg KUSER=myuser --build-arg KUSER=mygroup`

## CLI Options

Usage:

```txt
Executes a scan analysis

Usage:
  kics scan [flags]

Flags:
  -m, --bom                           include bill of materials (BoM) in results output
      --cloud-provider strings        list of cloud providers to scan (aws, azure, gcp)
      --config string                 path to configuration file
      --disable-full-descriptions     disable request for full descriptions and use default vulnerability descriptions
      --disable-secrets               disable secrets scanning
      --exclude-categories strings    exclude categories by providing its name
                                      cannot be provided with query inclusion flags
                                      can be provided multiple times or as a comma separated string
                                      example: 'Access control,Best practices'
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
  -q, --queries-path string           path to directory with queries (default "./assets/queries")
      --report-formats strings        formats in which the results will be exported (all, asff, cyclonedx, glsast, html, json, junit, pdf, sarif, sonarqube) (default [json])
  -r, --secrets-regexes-path string   path to secrets regex rules configuration file
      --timeout int                   number of seconds the query has to execute before being canceled (default 60)
  -t, --type strings                  case insensitive list of platform types to scan
                                      (Ansible, AzureResourceManager, Buildah, CloudFormation, Dockerfile, GRPC, GoogleDeploymentManager, Kubernetes, OpenAPI, Terraform)

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
