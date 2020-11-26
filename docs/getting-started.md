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

<!--
#### Release

```
TBD
```

#### Docker

KICS is also available as a Docker image and can be used as follows
```
TBD
```
-->

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

Want to go the next mile and contribute? [You're welcome!](contribution.md)