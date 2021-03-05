### GitHub Actions integration with SARIF

KICS has an option to generate results on SARIF formats, which can be integrated with many CI tools, [including GitHub Actions](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/integrating-with-code-scanning).

The following workflow shows how to integrate KICS with GitHub Actions:

```YAML
steps:
- uses: actions/checkout@v2
  - name: run kics Scan
    uses: checkmarx/kics-action@v1.0
    with:
      path: 'terraform'
      output-formats: 'sarif'
      output-path: 'results.sarif'
  - name: Upload SARIF file
    uses: github/codeql-action/upload-sarif@v1
    with:
      sarif_file: results.sarif
```

The results list can be found on security tab of your GitHub project and should loos like something as following:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-1.png" width="850">

And an entry should describe the error and which line it happened like following image:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/sarif-example-2.png" width="850">