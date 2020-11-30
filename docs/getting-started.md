## Installation

This section describes the installation steps for getting KICS up and running.

<!--
#### Default
-->

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
   go run ./cmd/console/main.go -p <path-of-your-project-to-scan> -o <output-results.json>
   ```


#### Release

```

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for both Linux and Windows operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries

So all you need is:

1. Go to KICS [releases](https://github.com/Checkmarx/kics/releases)
2. Click on latest release
3. Download KICS binaries based on your OS
4. Extract files
5. Run kics executable with the cli options as decribed below

```
kics.exe -p <path-of-your-project-to-scan> -o <output-results.json>

```

```

#### Docker

KICS is also available as a [Docker image](https://hub.docker.com/r/checkmarx/kics) and can be used as follows:  

``txt
docker pull checkmarx/kics:latest  
docker run -v {​​​​path_to_local_folder_to_scan}​​​​:/path checkmarx/kics:latest -p "/path" -o "/path/results.json"
```

## CLI Options

```txt
-h, --help                  help for iacScanner
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
