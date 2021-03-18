## Integration with Github Actions

You can integrate KICS into your Github Actions CI/CD pipelines with a specific KICS Github Action.

This provides you the ability to run KICS scans in your Github repositories and streamline vulnerabilities and misconfiguration checks to your infrastructure as code (IaC).

#### Tutorial

1. Edit the workflow file you want to integrate KICS in

2. Either search Github Marketplace or use the template below:

```yaml
- name: KICS Github Action
  uses: Checkmarx/kics-github-action@v1.0
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


#### Example
```yaml
#...
  steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2
     - name: run kics Scan
        uses: checkmarx/kics-github-action@v1.0
        with:
          path: 'terraform'
          output_path: 'results.json'
     - name: display kics results
        run: |
          cat results.json
```

Here you can see it in action:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/kics_scan_github_actions.png" width="850">

### GitHub Actions integration with SARIF

KICS has an option to generate results on SARIF format, which can be integrated with many CI tools, [including GitHub Actions](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/integrating-with-code-scanning).

The following workflow shows how to integrate KICS with GitHub Actions:

```YAML
steps:
- uses: actions/checkout@v2
  - name: run kics Scan
    uses: checkmarx/kics-action@v1.0
    with:
      path: 'terraform'
      output-path: 'results.sarif'
  - name: Upload SARIF file
    uses: github/codeql-action/upload-sarif@v1
    with:
      sarif_file: results.sarif
```

The results list can be found on security tab of your GitHub project and should look like the following image:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-1.png" width="850">

An entry should describe the error and in which line it occurred:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-2.png" width="850">


#### Resources

- KICS GitHub Action in <a href="https://github.com/marketplace/actions/kics-github-action" target="_blank">Github Marketplace</a>.
- KICS Github Action <a href="https://github.com/Checkmarx/kics-github-action" target="_blank" >Project Repository</a>.
- Github Actions in <a href="https://docs.github.com/en/free-pro-team@latest/actions/quickstart" target="_blank">Github Documentation</a>
