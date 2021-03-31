## Installation

There are multiple ways to get KICS up and running:

#### Docker

KICS is available as a <a href="https://hub.docker.com/r/checkmarx/kics" target="_blank">Docker image</a> and can be used as follows:

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

```txt
docker pull checkmarx/kics:latest
docker run -v {​​​​path_to_host_folder_to_scan}​​​​:/path checkmarx/kics:latest scan -p "/path" -o "/path/results.json"
```

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default *./assets/queries* is built-in in the image.

#### One-liner Install Script

Run the following command to download and install kics. It will detect your current OS and download the appropriate binary package, defaults installation to `./bin` the queries will be placed alongside the binary in `./bin/assets/queries`:

```sh
curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh | bash
```

If you want to place it somewhere else like `/usr/local/bin`:

```sh
sudo curl -sfL https://raw.githubusercontent.com/Checkmarx/kics/master/install.sh | bash -s -- -b /usr/local/bin
```

#### Binary

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for both Linux and Windows operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries

So all you need is:

1. Go to <a href="https://github.com/Checkmarx/kics/releases/latest" target="_blank">KICS releases</a>
1. Download KICS binaries based on your OS
1. Extract files
1. Run kics executable with the cli options as described below (note that kics binary should be located in the same directory as queries directory)
   ```
   ./kics scan -p <path-of-your-project-to-scan> -o <output-results.json>
   ```

#### Build from Sources

1. Download and install Go from <a href="https://golang.org/dl/" target="_blank">https://golang.org/dl/</a>
1. Clone the repository:
   ```
   git clone https://github.com/Checkmarx/kics.git
   ```
   ```
   cd kics
   ```
1. Kick a scan!
   ```
   go run ./cmd/console/main.go scan -p <path-of-your-project-to-scan> -o <output-results.json>
   ```

---

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
  -h, --help               help for kics
  -l, --log-file           writes log messages to log file
      --log-level string   determines log level (TRACE,DEBUG,INFO,WARN,ERROR,FATAL) (default "INFO")
      --log-path string    path to log files, (defaults to ${PWD}/info.log)
      --no-color           disable CLI color output
  -s, --silent             silence stdout messages (mutually exclusive with verbose)
  -v, --verbose            write logs to stdout too (mutually exclusive with silent)

Use "kics [command] --help" for more information about a command.
```

#### Scan Command Options

```txt
Executes a scan analysis

Usage:
  kics scan [flags]

Flags:
      --config string                path to configuration file
      --exclude-categories strings   exclude categories by providing its name
                                     can be provided multiple times or as a comma separated string
                                     example: 'Access control,Best practices'
  -e, --exclude-paths strings        exclude paths from scan
                                     supports glob and can be provided multiple times or as a quoted comma separated string
                                     example: './shouldNotScan/*,somefile.txt'
      --exclude-queries strings      exclude queries by providing the query ID
                                     can be provided multiple times or as a comma separated string
                                     example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'
  -x, --exclude-results strings      exclude results by providing the similarity ID of a result
                                     can be provided multiple times or as a comma separated string
                                     example: 'fec62a97d569662093dbb9739360942f...,31263s5696620s93dbb973d9360942fc2a...'
  -h, --help                         help for scan
      --minimal-ui                   simplified version of CLI output
      --no-progress                  hides the progress bar
  -o, --output-path string           directory path to store reports
  -p, --path string                  path or directory path to scan
  -d, --payload-path string          path to store internal representation JSON file
      --preview-lines int            number of lines to be display in CLI results (min: 1, max: 30) (default 3)
  -q, --queries-path string          path to directory with queries (default "./assets/queries")
      --report-formats strings       formats in which the results will be exported (json, sarif, html)
  -t, --type strings                 case insensitive list of platform types to scan
                                     (Ansible, CloudFormation, Dockerfile, Kubernetes, Terraform)

Global Flags:
  -l, --log-file           writes log messages to log file
      --log-level string   determines log level (TRACE,DEBUG,INFO,WARN,ERROR,FATAL) (default "INFO")
      --log-path string    path to log files, (defaults to ${PWD}/info.log)
      --no-color           disable CLI color output
  -s, --silent             silence stdout messages (mutually exclusive with verbose)
  -v, --verbose            write logs to stdout too (mutually exclusive with silent)
```

The other commands have no further options.

---

## Next Steps
- [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
- [Explore the queries internals](queries.md) for better understanding how KICS works.
- [Explore the output results format](results.md) and quickly fix the issues detected.
- [Contribute](CONTRIBUTING.md) if you want to go the extra mile.

