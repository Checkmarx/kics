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

KICS will use the following precedence to fill flags:

-   CLI flags
-   Environment variables
-   Configuration file

## Helm overrides

Helm overrides work with ordinary scans; `--experimental-helm-scan` is optional.
Use the `helm-overrides` section in a KICS configuration file:

```yaml
helm-overrides:
  global:
    values-files:
      - overrides/common.yaml
    set:
      - replicaCount=2
    set-string:
      - image.tag=2026.10
  charts:
    - path: charts/api
      values-files:
        - overrides/api-prod.yaml
      set:
        - service.type=ClusterIP
    - path: charts/worker
      set:
        - replicaCount=4
```

`global` applies to every chart. Each `charts` entry targets an exact chart
directory containing `Chart.yaml`, rather than the chart's metadata name.
Subchart settings belong under the dependency name or alias in the parent
chart's values. Duplicate chart selectors within one source are rejected.

All paths in this section, including values-file paths in chart-specific rules,
are relative to the configuration file. CLI paths are relative to the current
working directory. Absolute paths are also accepted. Values files must be local
files containing YAML mappings. Missing files, invalid selectors, unknown fields,
and malformed expressions fail validation before scanning. A valid selector
that is not encountered during the scan produces a warning, for example when
the chart is excluded from scanning.

Use `set` for Helm's typed `key=value` expressions and `set-string` to preserve
strings such as `001`. Both are lists of strings, preserving case-sensitive
keys such as `replicaCount`. Use values files for larger nested configurations.
The same section structure is supported in JSON and TOML.

The equivalent CLI flags are repeatable:

```sh
kics scan -p . \
  --helm-values overrides/common.yaml \
  --helm-set replicaCount=2 \
  --helm-set-string image.tag=2026.10 \
  --helm-chart-values "charts/api::overrides/api-prod.yaml" \
  --helm-chart-set "charts/api::service.type=ClusterIP" \
  --helm-chart-set "charts/worker::replicaCount=4"
```

`--helm-chart-set-string` provides chart-specific string overrides. The `::`
separator supports Windows paths, for example
`--helm-chart-values "C:\charts\api::C:\overrides\prod.yaml"`.
Quote expressions containing shell metacharacters, such as
`--helm-set 'items={one,two}'`. Helm handles commas and escaping inside each
expression; KICS does not split these flags as CSV lists. Use the structured
`helm-overrides` section in configuration files rather than these six flag names.

Precedence is applied from lowest to highest:

1. Chart defaults.
2. Automatically discovered values combinations, when experimental scanning is enabled.
3. Config global overrides.
4. Config chart-specific overrides.
5. CLI global overrides.
6. CLI chart-specific overrides.

Within each layer, values files merge in listed order, followed by `set`, then
`set-string`. Later entries win. Maps merge recursively; lists replace. Explicit
`false`, empty strings, and `null` are preserved as overrides. The corresponding
`KICS_HELM_*` environment variables can supply CLI defaults; an explicit CLI flag
replaces its environment default. A variable contains one complete expression
or path (which may itself use Helm's comma syntax).

Without experimental mode, KICS renders each chart once with its configured
values. With experimental mode, it applies these overrides to the baseline and
every discovered combination. Explicit values files are excluded from automatic
combination discovery. The fixer can repair unspecified values but cannot
replace explicitly supplied values or their containing structures. If a repair
would do so, that render fails with a diagnostic and other combinations continue.

Values files are read during configuration validation and reused for the scan.
Results use `configured` and `configured+<combination>` context labels; labels
do not contain override values. Omitting overrides preserves ordinary rendering.
