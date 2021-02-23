## Configuration File

KICS allow you to provide all configurations either as command line arguments or as code.

Here is a Configuration file example:

```JSON
{
  "path": "assets/iac_samples",
  "verbose": true,
  "log-file": true,
  "queries-path": "assets/queries",
  "output-path": "results.json"
}
```

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
  "path": "path to file or directory to scan",
  "verbose": true,
  "log-file": true,
  "queries-path": "path to directory with queries (default ./assets/queries) (default './assets/queries')",
  "output-path": "file path to store result in json format",
  "exclude-paths": "exclude paths or files from scan",
  "no-progress": false,
  "type": "type of queries to use in the scan",
  "payload-path": "file path to store source internal representation in JSON format",
  "exclude-results": "exclude results by providing a list of similarity IDs of a result"
}
```

#### YAML Format

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
exclude-results: "exclude results by providing a list of similarity IDs of a result"
```

#### TOML Format

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
exclude-results = "exclude results by providing a list of similarity IDs of a result"
```

#### HCL Format

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
"exclude-results" = "exclude results by providing a list of similarity IDs of a result"
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
