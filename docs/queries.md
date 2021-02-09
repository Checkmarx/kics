## Queries

KICS queries are written in OPA (Rego).

```Opa
CxPolicy [ result ] {
   resource := input.document[i].resource.aws_s3_bucket[name]
   role = "public-read"
   resource.acl == role
   
   result := {
        "documentId": 		input.document[i].id,
        "searchKey": 	    sprintf("aws_s3_bucket[%s].acl", [name]),
        "issueType":	    "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket[%s].acl is private", [name]),
        "keyActualValue": 	sprintf("aws_s3_bucket[%s].acl is %s", [name, role])
    }
}
```

### Anatomy

The anatomy of a query is straightforward. It builds up a policy and defines the result.

The **policy** builds the pattern that breaks the *security* of the infrastructure code and which the query is looking for.

The **result** defines the specific data used to present the *vulnerability* in the infrastructure code.


### Metadata

Each query has a metadata.json companion file with all the relevant information about the *vulnerability*, including 
the severity, category and its description.

For example, the JSON code above is the metadata corresponding to the query in the beginning of this document.
```json
{
  "id": "5738faf3-3fe6-4614-a93d-f0003242d4f9",
  "queryName": "All Users Group Gets Read Access",
  "severity": "HIGH",
  "category": "Identity and Access Management",
  "descriptionText": "It's not recommended to allow read access for all user groups.",
  "descriptionUrl": "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl"
}
```


### Organization
Filesystem-wise, KICS queries are organized per IaC technology or tool (e.g., terraform, k8s, dockerfile, etc.) and grouped 
under provider (e.g., aws, gcp, azure, etc.) when applicable.

Per each query created, it is mandatory the creation of **test cases** with, at least, one negative and positive case and a JSON file 
with data about the expected results, as shown below:
```json
[
	{
		"queryName": "All Users Group Gets Read Access",
		"severity": "HIGH",
		"line": 3
	}
]
```

Summarizing, the following is the expected file tree for a query:
```none
- <technology>
    |- <provider>
    |   |- <queryfolder>
    |   |   |- test
    |   |   |   |- positive<.ext>
    |   |   |   |- negative<.ext>
    |   |   |   |- positive_expected_result.json
    |   |   |- metadata.json
    |   |   |- query.rego
```
## Development of a Query 

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
- Install Open Policy Agent extension in VS Code and create a simple folder with a .rego file for the query and a input.json for the sample to test against

### Testing 

For a query to be considered complete, it must be compliant with at least one positive and one negative test case. To run the unit tests you can run this command:

```bash
go test -mod=vendor -v -cover ./... -count=1
```
Check if the new test was added correctly and if all tests are passing locally. If succeeds, a Pull Request can now be created.

### Guidelines

Filling metadata.json:

- 'id' should be filled with a UUID. You can use the built-in command to generate this:
```bash
go run ./cmd/console/main.go generate-id
```
- 'queryName' describes the name of the vulnerability
- 'severity' can be filled with 'HIGH', 'MEDIUM','LOW' or 'INFO'
- 'category' pick one of the following:
  - Identity and Access Management
  - Network Security
  - Monitoring
  - Encryption and Key Management
  - Logging
  - Operational
  - Cloud Assets Management
  - Vulnerability and Threat Management
  - Backup and Disaster Recovery
  - Domain Name System (DNS) 
  - Management
  - Network Ports Security
- 'descriptionText' should explain with detail the vulnerability and if possible provide a way to remediate
- 'descriptionUrl' points to the official documentation about the resource being targeted


## Best Practices 

Use built-in functions as much as possible.
