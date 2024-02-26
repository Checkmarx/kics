## Integration with Github Actions

You can integrate KICS into your Github Actions CI/CD pipelines with a specific KICS Github Action.

This provides you the ability to run KICS scans in your Github repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

#### Important note
If you use a version from **v1.2 to v1.5 of the kics-github-action** it means you will be scanning your IaC files with **KICS version 1.5.15**.</br></br>
In order to use **KICS version 1.7.x** to scan your files, you should use the **v1.7.0 of the kics-github-action**.

#### Tutorial

1. Edit the workflow file you want to integrate KICS in

2. Either search Github Marketplace or use the template below:

```yaml
- name: KICS Github Action
  uses: Checkmarx/kics-github-action@v1.7.0
  with:
    # path to file or directory to scan
    path:
    # file path to store result in json format
    output_path: # optional
    # file path to store source internal representation in JSON format
    payload_path: # optional
    # path to directory with queries (default "./assets/queries")
    queries: # optional
    # verbose scan
    verbose: # optional
```

Refer to [kics-github-action](https://github.com/Checkmarx/kics-github-action) repository for a full list of parameters

### GitHub Actions integration with SARIF

KICS has an option to generate results on SARIF format, which can be integrated with many CI tools, [including GitHub Actions](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/integrating-with-code-scanning).

The following workflow shows how to integrate KICS with GitHub Actions:

```YAML
steps:
  - uses: actions/checkout@v2
  - name: Mkdir results-dir
    # make sure results dir is created
    run: mkdir -p results-dir
  - name: run kics Scan
    uses: Checkmarx/kics-github-action@v1.7.0
    with:
      path: 'terraform'
      output_path: results-dir
  - name: Upload SARIF file
    uses: github/codeql-action/upload-sarif@v3
    with:
      sarif_file: results-dir/results.sarif
```

The results list can be found on security tab of your GitHub project and should look like the following image:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-1.png" width="850">

An entry should describe the error and in which line it occurred:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-2.png" width="850">

## Default report Usage example

```yaml
    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2
    - name: Mkdir results-dir
      # make sure results dir is created
      run: mkdir -p results-dir
    # Scan Iac with kics
    - name: run kics Scan
      uses: checkmarx/kics-github-action@latest
      with:
        path: 'terraform'
        output_path: results-dir
    # Display the results in json format
    - name: display kics results
      run: |
        cat results-dir/results.json
      # optionally parse the results with jq
      # jq '.total_counter' results-dir/results.json
      # jq '.queries_total' results-dir/results.json
```

Here you can see it in action:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_scan_github_actions.png" width="850">

## Workflow failures

By default KICS will fail your workflow on any results found.

### Fail by severity usage example

If you want your pipeline just to fail on HIGH, MEDIUM severity results and KICS engine execution errors:

```yaml
    steps:
    - uses: actions/checkout@v2
    - name: Mkdir results-dir
      # make sure results dir is created
      run: mkdir -p results-dir
    - name: run kics Scan
      uses: checkmarx/kics-github-action@latest
      with:
        path: 'terraform,my-other-sub-folder/Dockerfile'
        fail_on: high,medium
        output_path: results-dir
    - name: display kics results
      run: |
        cat results-dir/results.json
```

### Don't fail on results

If you want KICS to ignore the results and return exit status code 0 unless a KICS engine error happens:

```yaml
    steps:
    - uses: actions/checkout@v2
    - name: Mkdir results-dir
      # make sure results dir is created
      run: mkdir -p results-dir
    - name: run kics Scan
      uses: checkmarx/kics-github-action@latest
      with:
        path: 'terraform'
        ignore_on_exit: results
        output_path: results-dir
    - name: display kics results
      run: |
        cat results-dir/results.json
```


## Profiling KICS

You can only enable one profiler at a time, CPU or MEM.

> 📝 &nbsp; Please note that execution time may be impacted by enabling performance profiler due to sampling

```yaml
    steps:
    - uses: actions/checkout@v2
    - name: Mkdir results-dir
      # make sure results dir is created
      run: mkdir -p results-dir
    - name: run kics Scan
      uses: checkmarx/kics-github-action@latest
      with:
        path: 'terraform'
        profiling: MEM
        output_path: results-dir
    - name: display kics results
      run: |
        cat results-dir/results.json
```

## Uploading SARIF report


```yaml
name: scan with KICS and upload SARIF

on:
  pull_request:
    branches: [master]

jobs:
  kics-job:
    runs-on: ubuntu-latest
    name: kics-github-action
    steps:
      - name: Checkout repo
        uses: actions/checkout@v2
      - name: Mkdir results-dir
        # make sure results dir is created
        run: mkdir -p results-dir
      - name: Run KICS Scan with SARIF result
        uses: checkmarx/kics-github-action@latest
        with:
          path: 'terraform'
          # when provided with a directory on output_path
          # it will generate the specified reports file named 'results.{extension}'
          # in this example it will generate:
          # - results-dir/results.json
          # - results-dir/results.sarif
          output_path: results-dir
          platform_type: terraform
          output_formats: 'json,sarif'
          exclude_paths: "terraform/gcp/big_data.tf,terraform/azure"
          # seek query id in it's metadata.json
          exclude_queries: 0437633b-daa6-4bbc-8526-c0d2443b946e
      - name: Show results
        run: |
          cat results-dir/results.sarif
          cat results-dir/results.json
      - name: Upload SARIF file
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results-dir/results.sarif
```

## Using configuration file

Check [configuration file](https://github.com/Checkmarx/kics/blob/master/docs/configuration-file.md) reference for more options.

```yaml
name: scan with KICS using config file

on:
  pull_request:
    branches: [master]

jobs:
  kics-job:
    runs-on: ubuntu-latest
    name: kics-github-action
    steps:
      - name: Checkout repo
        uses: actions/checkout@v2
      - name: Mkdir results-dir
        # make sure results dir is created
        run: mkdir -p results-dir
      - name: Create config file
        # creating a heredoc config file
        run: |
          cat <<EOF >>kics.config
          {
            "exclude-categories": "Encryption",
            "exclude-paths": "terraform/gcp/big_data.tf,terraform/gcp/gcs.tf",
            "log-file": true,
            "minimal-ui": false,
            "no-color": false,
            "no-progress": true,
            "output-path": "./results-dir",
            "payload-path": "file path to store source internal representation in JSON format",
            "preview-lines": 5,
            "report-formats": "json,sarif",
            "type": "terraform",
            "verbose": true
          }
          EOF
      - name: Run KICS Scan using config
        uses: checkmarx/kics-github-action@latest
        with:
          path: 'terraform'
          config_path: ./kics.config
      - name: Upload SARIF file
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results-dir/results.sarif
```

#### Resources

- KICS GitHub Action in <a href="https://github.com/marketplace/actions/kics-github-action" target="_blank">Github Marketplace</a>.
- KICS Github Action <a href="https://github.com/Checkmarx/kics-github-action" target="_blank" >Project Repository</a>.
- Github Actions in <a href="https://docs.github.com/en/free-pro-team@latest/actions/quickstart" target="_blank">Github Documentation</a>
