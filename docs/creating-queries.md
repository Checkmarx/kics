## Create a new Query 

The queries are written in Rego and our internal parser transforms every IaC file that supports into a universal JSON format. This way anyone can start working on a query by picking up a small sample of the vulnerability that the query should target, and convert this sample, that can be a .tf or .yaml file, to our JSON structure JSON. To convert the sample you can run the following command:

```bash
go run ./cmd/console/main.go -p "pathToTestData" -d "pathToGenerateJson"
```

So for example, if we wanted to transform a .tf file in ./code/test we could type:
```bash
go run ./cmd/console/main.go -p  "./src/test" -d "src/test/input.json"
```
After having the .json that will be our Rego input, we can begin to write queries.
To test and debug there are two ways:

- [Using Rego playground](https://play.openpolicyagent.org/)
- [Install Open Policy Agent extension](https://marketplace.visualstudio.com/items?itemName=tsandall.opa) in VS Code and create a simple folder with a .rego file for the query and a input.json for the sample to test against

#### Testing 

For a query to be considered complete, it must be compliant with at least one positive and one negative test case. To run the unit tests you can run this command:

```bash
go test -mod=vendor -v -cover ./... -count=1
```
Check if the new test was added correctly and if all tests are passing locally. If succeeds, a Pull Request can now be created.

#### Guidelines

Filling metadata.json:

- `id` should be filled with a UUID. You can use the built-in command to generate this:
```bash
go run ./cmd/console/main.go generate-id
```
- `queryName` describes the name of the vulnerability
- `severity` can be filled with `HIGH`, `MEDIUM`, `LOW` or `INFO`
- `category` pick one of the following:
  - Access Control
  - Availability
  - Backup
  - Best Practices
  - Build Process
  - Encryption
  - Insecure Configurations
  - Insecure Defaults
  - Networking and Firewall
  - Observability
  - Resource Management
  - Secret Management
  - Supply-Chain
- `descriptionText` should explain with detail the vulnerability and if possible provide a way to remediate
- `descriptionUrl` points to the official documentation about the resource being targeted
- `platform` query target platform (e.g. Terraform, Kubernetes, etc.)