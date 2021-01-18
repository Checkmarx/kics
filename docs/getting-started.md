## Installation

There are multiple ways to get KICS up and running:


### Docker

KICS is available as a [Docker image](https://hub.docker.com/r/checkmarx/kics) and can be used as follows:  

To scan a directory/file on your host you have to mount it as a volume to the container and specify the path on the container filesystem with the -p KICS parameter (see Scan Command Options section below)

```txt
docker pull checkmarx/kics:latest  
docker run -v {​​​​path_to_host_folder_to_scan}​​​​:/path checkmarx/kics:latest scan -p "/path" -o "/path/results.json"
```  

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used The default *./assets/queries* is built-in in the image.

### Binary

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for both Linux and Windows operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries

So all you need is:

1. Go to [KICS releases](https://github.com/Checkmarx/kics/releases/latest)
1. Download KICS binaries based on your OS
1. Extract files
1. Run kics executable with the cli options as described below (note that kics binary should be located in the same directory as queries directory)  
   ```
   ./kics scan -p <path-of-your-project-to-scan> -o <output-results.json>
   ```

### Build from Sources

1. Download and install Go from [https://golang.org/dl/](https://golang.org/dl/)  
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

### CLI Commands

```txt
generate-id Generates uuid for query
help        Help about any command
scan        Executes a scan analysis
version     Displays the current version
```


### Scan Command Options

```txt
-h, --help                  help
-o, --output-path string    file path to store result in json format
-p, --path string           path to file or directory to scan
-d, --payload-path string   file path to store source internal representation in JSON format
-q, --queries-path string   path to directory with queries (default "./assets/queries")
-v, --verbose               verbose scan
```

## Next Steps

- Check how you can easily [integrate it into your CI](integrations.md) for any project.
- [Explore the output results format](results.md) and quickly fix the issues detected.


## Contribution

Want to go the next mile and contribute? [You're welcome!](CONTRIBUTING.md)
