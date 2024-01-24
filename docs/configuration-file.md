## Configuration File

KICS allow you to provide all configurations either as command line arguments or as code. You can see all possible configurations in the [CLI](commands.md#scan-command-options).
You can disable scanning in certain parts of file using inline comments. More can be found in [Running KICS](running-kics.md#using-commands-on-scanned-files-as-comments) section.

KICS supports JSON, TOML, YAML, and HCL formats for the configuration files, and it is able to infer the formats without the need of file extension.

  > 📝 &nbsp; flags that can receive multiple values can be either provided as a comma separated string or an array as in the example above

## Examples
#### JSON

```JSON
{
  "path": "assets/iac_samples",
  "verbose": true,
  "log-file": true,
  "type": "Dockerfile,Kubernetes",
  "queries-path": "assets/queries",
  "exclude-paths": [
     "foo/",
     "bar/",
  ],
  "output-path": "results"
}
```

#### YAML
The same example now in YAML format passing `type` as an array of strings:

```YAML
path: assets/iac_samples
verbose: true
log-file: true
type:
  - Dockerfile
  - Kubernetes
queries-path: "assets/queries"
exclude-paths:
  - "foo/"
  - "bar/"
output-path: "results"
```

#### TOML

```TOML
path = "assets/iac_samples"
verbose = true
log-file = true
type = "Dockerfile,Kubernetes"
queries-path = "assets/queries"
exclude-paths = [ "foo/", "bar/" ]
output-path = "results"
```

#### HCL

```hcl
"path" = "assets/iac_samples"
"verbose" = true
"log-file" = true
"type" = "Dockerfile,Kubernetes"
"queries-path" = "assets/queries"
"exclude-paths" = ["foo/", "bar/"]
"output-path" = "results"
```

---

## How to Use

You can enclose all your configurations in a file and use it in two different ways.

#### Command Argument File

1. Create a file with any name/any extension. For the sake of example, let's call it `kics-config.json`
2. Add the necessary configurations as shown in the templates section in any of the supported formats.
3. Pass the configuration file as argument:

```
docker run -t -v {path_to_kics_config}:/kics -v {path_to_host_folder_to_scan}:/path checkmarx/kics scan -p /path --config /kics/kics-config.json
```

#### Configuration as Code

1. Create a file named `kics.config` and place it in the root of your project repository.
2. Add the necessary configurations as shown in the templates section in any of the supported formats.
3. Invoke KICS without arguments (KICS will search for the specific file in the root)

```
docker run -t -v {path_to_host_folder_to_scan}:/path checkmarx/kics scan -p /path
```

**Note**: If more than one path is given, KICS will warn that `--config` must be used to explicit decide.

#### Environment variables

KICS also accepts environment variables to fill flags values. To use it you just need to have the flag with a `KICS_` prefix. For example:

-   To use path flag as environment variable, you should have `KICS_PATH` on your environment;
-   To use multiple names variables, like `--output-path`, you should use it with `KICS_` and each word separated by `_`, e.g.: `KICS_OUTPUT_PATH`

## Flags precedence

KICS will use the following precende to fill flags:

-   CLI flags
-   Environment variables
-   Configuration file
