## Configuration File

Configuration file example:

```JSON
{
  "path": "assets/queries",
  "verbose": true,
  "log-file": true,
  "queries-path": "assets/queries",
  "output-path": "results.json"
}
```

## Supported extensions

    -JSON
    -TOML
    -YAML
    -HCL

## How to Add and Run a Configuration File

1. Start by creating a file called 'config' using your preferred extension.
2. From the templates section, look for the extension you used and copy its content to your 'config' file changing the content as needed.
3. To use KICS with your configuration file, run the command:
```
go run ./cmd/console/main.go scan --config <path-of-configuration-file>
```

(CLI flags will have priority over the configuration file properties)

# Templates

## JSON Format

```JSON
{
  "path": "path to file or directory to scan",
  "verbose": true,
  "log-file": true,
  "queries-path": "path to directory with queries (default ./assets/queries) (default './assets/queries')",
  "output-path": "file path to store result in json format",
  "exclude-paths": "exclude paths or files from scan",
  "no-progress": false,
  "type": "type of queries to use in the scan",
  "payload-path": "file path to store source internal representation in JSON format"
}
```

## YAML Format

```YAML
path: "path to file or directory to scan"
verbose: true
log-file: true
queries-path: "path to directory with queries (default ./assets/queries) (default './assets/queries')"
output-path: "file path to store result in json format"
exclude-paths: "exclude paths or files from scan"
no-progress: false
type: "type of queries to use in the scan"
payload-path: "file path to store source internal representation in JSON format"
```

## TOML Format

```TOML
path = "path to file or directory to scan"
verbose = true
log-file = true
queries-path = "path to directory with queries (default ./assets/queries) (default './assets/queries')"
output-path = "file path to store result in json format"
exclude-paths = "exclude paths or files from scan"
no-progress = false
type = "type of queries to use in the scan"
payload-path = "file path to store source internal representation in JSON format"
```

## HCL Format

```hcl
"exclude-paths" = "exclude paths or files from scan"
"log-file" = true
"no-progress" = false
"output-path" = "file path to store result in json format"
"path" = "path to file or directory to scan"
"payload-path" = "file path to store source internal representation in JSON format"
"queries-path" = "path to directory with queries (default ./assets/queries) (default './assets/queries')"
"type" = "type of queries to use in the scan"
"verbose" = true
```
