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

## KICS Commands
KICS can interpret the following commands:

```txt
generate-id Generates uuid for query
help        Help about any command
scan        Executes a scan analysis
version     Displays the current version
```

#### Scan Command Options

```txt
Executes a scan analysis

Usage:
  kics scan [flags]

Flags:
      --config string             path to configuration file
  -e, --exclude-paths strings     exclude paths or files from scan
                                  The arg should be quoted and uses comma as separator
                                  example: './shouldNotScan/*,somefile.txt'
  -s, --exclude-results strings   exclude results by providing the similarity ID of a result
                                  The arg should be quoted and uses comma as separator
                                  example: 'fec62a97d569662093dbb9739360942fc2a0c47bedec0bfcae05dc9d899d3ebe,31263s5696620s93dbb973d9360942fc2a...'
  -h, --help                      help for scan
  -l, --log-file                  log to file info.log
      --no-progress               hides scan's progress bar
  -o, --output-path string        file path to store result in json format
  -p, --path string               path to file or directory to scan
  -d, --payload-path string       file path to store source internal representation in JSON format
  -q, --queries-path string       path to directory with queries (default ./assets/queries) (default "./assets/queries")
  -t, --type strings              type of queries to use in the scan
  -v, --verbose                   verbose scan
```

The other commands have no further options.

---

## Next Steps
- [Understand how to configure KICS](configuration-file.md) so you can have a better KICS experience.
- [Explore the queries internals](queries.md) for better understanding how KICS works.
- [Explore the output results format](results.md) and quickly fix the issues detected.
- [Contribute](CONTRIBUTING.md) if you want to go the extra mile.

