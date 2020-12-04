## Installation

There are multiple ways to get KICS up and running:


#### Docker

KICS is available as a [Docker image](https://hub.docker.com/r/checkmarx/kics) and can be used as follows:  

```
docker pull checkmarx/kics:latest  
docker run -v {​​​​path_to_local_folder_to_scan}​​​​:/path checkmarx/kics:latest -p "/path" -o "/path/results.json"
```  

You can provide your own path to the queries folder, otherwise the default folder will be used (default "./assets/queries")

```
-q, --queries-path string   path to directory with queries (default "./assets/queries" - built in the image)
```  

#### Binary

KICS release process is pretty straightforward.
When we're releasing a new version, we'll pack KICS executables for both Linux and Windows operating systems.
Our security queries will be included in the ZIP files and tarballs, so that you can scan your IaC code with the out-of-the-box queries

So all you need is:

1. Go to [KICS releases](https://github.com/Checkmarx/kics/releases/latest)
1. Download KICS binaries based on your OS
1. Extract files
1. Run kics executable with the cli options as decribed below (note that kics binary should be located in the same folder as queries folder)  

```
./kics -p <path-of-your-project-to-scan> -o <output-results.json>
```

#### Build from Sources

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


#### CLI Options

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
