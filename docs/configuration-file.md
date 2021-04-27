## Configuration File

KICS allow you to provide all configurations either as command line arguments or as code.

Here is a Configuration file example:

```JSON
{
  "path": "assets/iac_samples",
  "verbose": true,
  "log-file": true,
  "type": "Dockerfile,Kubernetes",
  "queries-path": "assets/queries",
  "output-path": "results.json"
}
```

The same example now in YAML format passing `type` as an array of strings:

```YAML
path: assets/iac_samples
verbose: true
log-file: true
type:
  - Dockerfile
  - Kubernetes
queries-path: "assets/queries"
output-path: "results.json"
```

> 📝 flags that can receive multiple values can be either provided as a comma separated string or an array as in the example above

---

## Supported Formats
KICS supports the following formats for the configuration files.

- JSON
- TOML
- YAML
- HCL

Notice that format is about the content and not the file extension.

KICS is able to infer the format without the need of file extension.

---

## Templates

#### JSON Format

```JSON
{
  "exclude-categories": "exclude categories by providing its name",
  "exclude-paths": "exclude paths or files from scan",
  "exclude-queries": "exclude queries by providing the query ID",
  "exclude-results": "exclude results by providing a list of similarity IDs of a result",
  "log-file": true,
  "log-level": "INFO",
  "log-path": "path to the log file",
  "silent": false,
  "minimal-ui": false,
  "no-color": false,
  "no-progress": false,
  "output-path": "directory path to store reports",
  "path": "path to file or directory to scan",
  "payload-path": "file path to store source internal representation in JSON format",
  "preview-lines": 3,
  "queries-path": "path to directory with queries (default ./assets/queries) (default './assets/queries')",
  "report-formats": "formats in which the results will be exported (json, sarif, html)",
  "type": "type of queries to use in the scan",
  "verbose": true,
  "profiling": "enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)"
}
```

#### YAML Format

```YAML
exclude-categories: "exclude categories by providing its name"
exclude-paths: "exclude paths or files from scan"
exclude-queries: "exclude queries by providing the query ID"
exclude-results: "exclude results by providing a list of similarity IDs of a result"
log-file: true
log-level: INFO
log-path: path to the log file
silent: false
no-color: false
minimal-ui: false
no-progress: false
output-path: "directory path to store reports"
path: "path to file or directory to scan"
payload-path: "file path to store source internal representation in JSON format"
preview-lines: 3
queries-path: "path to directory with queries (default ./assets/queries) (default './assets/queries')"
report-formats: "formats in which the results will be exported (json, sarif, html)"
type: "type of queries to use in the scan"
verbose: true
profiling: "enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)"
```

#### TOML Format

```TOML
exclude-categories = "exclude categories by providing its name"
exclude-paths = "exclude paths or files from scan"
exclude-queries = "exclude queries by providing the query ID"
exclude-results = "exclude results by providing a list of similarity IDs of a result"
log-file = true
log-level = "INFO"
log-path = "path to the log file"
silent = false
minimal-ui = false
no-color = false
no-progress = false
output-path = "directory path to store reports"
path = "path to file or directory to scan"
payload-path = "file path to store source internal representation in JSON format"
preview-lines = 3
queries-path = "path to directory with queries (default ./assets/queries) (default './assets/queries')"
report-formats = "formats in which the results will be exported (json, sarif, html)"
type = "type of queries to use in the scan"
verbose = true
profiling = "enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)"
```

#### HCL Format

```hcl
"exclude-categories" = "exclude categories by providing its name"
"exclude-paths" = "exclude paths or files from scan"
"exclude-queries" = "exclude queries by providing the query ID"
"exclude-results" = "exclude results by providing a list of similarity IDs of a result"
"log-file" = true
"log-level" = "INFO"
"log-path" = "path to the log file"
"silent" = false
"minimal-ui" = false
"no-color" = false
"no-progress" = false
"output-path" = "directory path to store reports"
"path" = "path to file or directory to scan"
"payload-path" = "file path to store source internal representation in JSON format"
"preview-lines" = 3
"queries-path" = "path to directory with queries (default ./assets/queries) (default './assets/queries')"
"report-formats" = "formats in which the results will be exported (json, sarif, html)"
"type" = "type of queries to use in the scan"
"verbose" = true
"profiling" = "enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)"
```

---


## How to Use
You can enclose all your configurations in a file and use it in two different ways.

#### Command Argument File

1. Create a file with any name/any extension. For the sake of example, let's call it `kics-config.json`
2. Add the necessary configurations as shown in the templates section in any of the supported formats.
3. Pass the configuration file as argument:
```
kics scan --config kics-config.json
```

#### Configuration as Code

1. Create a file named `kics.config` and place it in the root of your project repository.
2. Add the necessary configurations as shown in the templates section in any of the supported formats.
3. Invoke KICS without arguments (KICS will search for the specific file in the root)
```
kics scan
```

**Note**: CLI flags will have priority over the configuration file properties!
