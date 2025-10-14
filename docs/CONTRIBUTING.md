## Contribution

We would like to THANK YOU for considering contributing to KICS!

KICS is a true community project. It's built as an open source from day one, and anyone can find his own way to contribute to the project.

Within just minutes, you can start making a difference, by sharing your expertise with a community of thousands of security experts and software developers.

#### Contribution Options

Good news! You don't have to contribute code. There are plenty of ways you can contribute to KICS project:

- Reporting new [bugs or issues](https://github.com/Checkmarx/kics/issues)
- Help triaging issues
- Improving and translating the documentation
- Volunteering to maintain the project

#### Code of Conduct

By participating and contributing to the project, you agree to uphold our [Code of Conduct](code-of-conduct.md).

---

## Get Started!

Follow the instructions below to setup local KICS development environment and push your changes.

1. Fork the `kics` repo on GitHub.
2. Download and install Go 1.16 or higher from <a href="https://golang.org/dl/" target="_blank">https://golang.org/dl/</a>.
3. Clone your fork locally:
   ```shell
   git clone https://github.com/Checkmarx/kics.git
   ```
4. Create a branch for local development.
Use succinct but descriptive name (prefix with *feature/issue#-descriptive-name>* or *hotfix/issue#-descriptive-name*):
   ```sh
   git checkout -b <name-of-your-issue>
   ```
5. Make your changes locally.
   We recommend running the E2E tests by following the steps recommended in the [README](https://github.com/Checkmarx/kics/blob/master/e2e/README.md).
   
6. Validate your changes to reassure they meet project quality and contribution standards:
   ```sh
   golangci-lint run
   ```
   ```sh
   go mod vendor
   ```
   ```sh
   go test -mod=vendor -v ./...
   ```
7. Commit your changes and push your branch to GitHub:
   ```sh
   git add .
   ```
   We recommend following [conventional commits messages](https://www.conventionalcommits.org/en/v1.0.0-beta.2/)
   ```sh
   git commit -m "feat(CLI): add new flag --blabla"
   ```
   ```sh
   git push --set-upstream origin <name-of-your-issue>
   ```
8. Submit a pull request on GitHub website.
   
   If the changes do not pass the pipeline, we recommend following the steps outlined [here](#tips), which cover some common cases.

---

## How to Contribute

Contributions are made to this repo via Issues and Pull Requests (PRs).  A few general guidelines that cover both:

- Search for existing [issues](https://github.com/Checkmarx/kics/issues) and [pull requests](https://github.com/Checkmarx/kics/pulls) before creating your own to avoid duplicates.
- PRs will only be accepted if associated with an issue (enhancement or bug) that has been submitted and reviewed/labeled as *accepted*.
- We will work hard to make sure issues that are raised are handled in a timely manner.

#### Issues

Issues should be used to report problems with the solution / source code, request a new feature, or to discuss potential changes before a PR is created. When you create a new Issue, a template will be loaded that will guide you through collecting and providing the information we need to investigate.

If you find an Issue that addresses the problem you're having, please add your own reproduction information to the existing issue rather than creating a new one. Adding a [reaction](https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/) can also help by indicating to our maintainers that a particular problem is affecting more than just the reporter.


#### Pull Requests

Pull Requests (PRs) are always welcome and can be a quick way to get your fix or improvement slated for the next release. In general, PRs should:

- Only fix/add the functionality in question **or** address code style issues, not both.
- Ensure all necessary details are provided and adhered to.
- Add unit or integration tests for fixed or changed functionality (if a test suite already exists) or specify steps taken to ensure changes were tested and functionality works as expected.
- Address a single concern in the least number of changed lines as possible.
- Include documentation in the repo or Provide additional comments in Markdown comments that should be pulled/reflected in GitHub Wiki for the given project.
- Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

For changes that address core functionality or would require breaking changes (e.g. a major release), please open an Issue to discuss your proposal first.

#### Pull Request Guidelines

Before you submit a pull request, please reassure that it meets these guidelines:

1. All validations and tests passed locally.
2. The pull request includes tests.
3. The relevant docs are updated, whether you're pushing new functionality or updating a query.
4. The pull request title should follow conventional commit messages:

`<type>(<scope>): <subject>`
where `(<scope>)` is optional

```
feat - A new feature (example scopes: engine, parser, flags, query)
fix - A bug fix
docs - Documentation only changes, (example scopes: catalog, guides, platforms, architecture)
test - Adding missing tests or correcting existing tests (example scopes: unit, e2e)
ci - Changes to our CI configuration files and scripts (example scopes: ghactions, linters)
chore - Other changes that don't modify src or test files
build - Changes that affect the build system or external dependencies (example scope: makefile)
style - Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
refactor - A code change that neither fixes a bug nor adds a feature
perf - A code change that improves performance
revert - Reverts a previous commit
```

e.g: `build(makefile): enhance make clean task`

#### Templates

The following templates will be used when [creating a new issue](https://github.com/Checkmarx/kics/issues/new/choose):

- Enhancement/Feature Request Template
- New (Approved) Feature Template
- Query Template
- Bug Report Template

---

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)

Join the [GitHub discussions](https://github.com/Checkmarx/kics/discussions).
Or contact KICS core team at [kics@checkmarx.com](mailto:kics@checkmarx.com)

And become one of our top contributors!

---

## Tips 

### Github Actions failing on E2E tests

If an E2E test causes failures in Github actions, the recommended steps are: 

1. Open the action that causes failure.
2. Go to Summary tab.
3. On the Summary page, go to the bottom of the page and download any artifact that does not have a `.dockerbuild` extension.
4. Extract the e2e-report and open the HTML in a browser.
5. Filter the tests to display only those that failed.
6. Check which test is causing the issue (e.g., E2E-CLI-032) and review the error description (e.g. number of lines not matching the expected value).
7. Navigate to the `e2e/testcases` directory on [KICS github repository](https://github.com/Checkmarx/kics/tree/master/e2e/testcases) and open the Go file corresponding to the failing test (e.g. `e2e-cli-032_scan_output-path_validate_json.go`).

8. Manually run a scan using the arguments provided in the file. 
   Example for `E2E-CLI-032`:   
   ```sh
   go run .\cmd\console\main.go scan -o "/path/e2e/output" --output-name "E2E_CLI_032_RESULT" -p "/path/e2e/fixtures/samples/positive.yaml"
   ``` 
   Here, `/path/e2e/output` is where the scan results will be stored, and `/path/e2e/fixtures/samples/positive.yaml` is the input file that should be used by replacing path with the path to `positive.yaml` on your local machine.

9. Navigate to the path specified by the `-o` flag and compare the generated file with the version in the [fixtures directory of the KICS repository](https://github.com/Checkmarx/kics/tree/master/e2e/fixtures).

10. Merge the generated file or add any missing data to the original file in the repository. **Example**: paste the generated `E2E_CLI_032_RESULT` into `e2e/fixtures/e2e/E2E_CLI_032_RESULT.json`.

11. Correct the path, to `/path/e2e/fixtures/samples/positive.yaml`, if it currently points to a local machine directory. **Example**: change `C:\Users\john\Desktop\kics\e2e\fixtures\samples\positive.yaml` to `/path/e2e/fixtures/samples/positive.yaml`.

12. Commit and push the changes.

### GitGuard Security Checks failing on the pipeline

If the pipeline fails when submitting a Pull Request, it may be due to GitGuard detecting a secret. In such cases, the KICS team will review the detected secret. If the secret is confirmed to be used only for testing purposes, the action will be marked as a False Positive and can be safely ignored.

### Flaky tests

There is a known set of tests that are considered flaky. These tests may fail intermittently due to timming issues, external dependencies or environment-specific conditions, rather than actual problems on the code. The team is aware of these cases and continues to monitor and improve them. 

Below is a list of currently identified flaky tests:

- CycloneDX
- analyserPaths

Tests that compare terminal output are particularly prone to flakiness. Typically, a flacky test is detected when, for the unit tests, it passes for some of the operating systems but, for one in specific it does not. Normally, for this cases it's a flacky test, and the KICS team should re-run the actions. 

### Unit tests

When a unit test fails in the KICS pipeline, there are two recommended approaches:

1. Open the failing unit-test page, go to **Test and Generate Report Dev**, wait for the report to generate, then search for `FAIL:` to identify the issue.

2. Alternatively, access the **Summary** tab, download the artifact that includes the failing OS in its name (or any artifact if all OS tests fail), open it, and search for `FAIL:` or the name of the query (e.g., `user_data_contains_encoded_private_key`).

Unit test failures can occur due to incorrectly defined lines in `positive_expected_result.json` or missing tests in that file.

### Grype or Trivy tests failing

Sometimes the KICS pipelines may fail due to issues in the Grype and Trivy tests. In such cases, it might be sufficient to just update a package version on the `go.mod` file. For such cases here are the recommended steps:

1. Open the action that is currently failing.
2. Go to the `Summary` tab on the top left corner.
3. Go to the `Grype docker image scan` or `Trivy docker image scan` jobs.
4. Download the artifact `trivy-fs-scan-results` or similar.
5. Open the `results.txt` file and check if there is any table that suggests which version of the package is causing the problem.
6. After that, go to the `go.mod` file that is on the root of the repository, change the version of the package to the version that is suggested on the file `results.txt` downloaded, under "fixed version".
7. Run `go mod tidy`.
8. Run `go mod vendor`.
9. Commit and push the changes.

NOTE: This is only a solution to solve the cases when the results provide a package that is on `go.mod` file and has a recommended fixed version. In some cases, there is no recommended version for the package on the `results.txt` or the package/library mentioned on the file is not on the `go.mod` file. For these cases, the typical solution is to update the image defined in the `Dockerfile`.

To check for the latest images available, you can refer to [dockerhub checkmarx community organization](https://hub.docker.com/u/checkmarx)

---

Special thanks to  **[Lior Kaplan](https://github.com/kaplanlior)** from **_Kaplan Open Source Consulting_** for his assistance in creating KICS. 