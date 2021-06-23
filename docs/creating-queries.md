## Create a new Query

The queries are written in Rego and our internal parser transforms every IaC file that supports into a universal JSON format. This way anyone can start working on a query by picking up a small sample of the vulnerability that the query should target, and convert this sample, that can be a .tf or .yaml file, to our JSON structure JSON. To convert the sample you can run the following command:

```bash
go run ./cmd/console/main.go scan -p "pathToTestData" -d "pathToGenerateJson"
```

So for example, if we wanted to transform a .tf file in ./code/test we could type:
```bash
go run ./cmd/console/main.go scan -p  "./src/test" -d "src/test/input.json"
```
After having the .json that will be our Rego input, we can begin to write queries.
To test and debug there are two ways:

- [Using Rego playground](https://play.openpolicyagent.org/)
- [Install Open Policy Agent extension](https://marketplace.visualstudio.com/items?itemName=tsandall.opa) in VS Code and create a simple folder with a .rego file for the query and a input.json for the sample to test against

#### Query Development Tutorial

In the first instance, take a look at the query composition:
- **query.rego**: Includes the policy and defines the result. The policy builds the pattern that breaks the security of the infrastructure code, which the query is looking for. The result defines the specific data used to present the vulnerability in the infrastructure code.
- **metadata.json**: Each query has a metadata.json companion file with all the relevant information about the vulnerability, including the severity, category and its description;
- **test**: folder that contains at least one negative and positive case and a JSON file with data about the expected results.

```
- <technology>
    |- <provider>
    |   |- <queryfolder>
    |   |   |- test
    |   |   |   |- positive1<.ext>
    |   |   |   |- positive2<.ext>
    |   |   |   |- negative1<.ext>
    |   |   |   |- negative2<.ext>
    |   |   |   |- positive_expected_result.json
    |   |   |- metadata.json
    |   |   |- query.rego
```

Now, focus on the content of each file:

👨‍💻 **REGO File**

As a first step, it is important to be familiar with the libraries available (check them in `assets/libraries`) and the JSON structure (Rego input). Also, we need to study all the possible cases related to the vulnerability we want to verify before starting the implementation.

For example, if we want to verify if the AWS CloudTrail has MultiRegion disabled in a Terraform sample, we need to focus on the attribute `is_multi_region_trail` of the resource `aws_cloudtrail`. Since this attribute is optional and false by default, we have two cases: (1) `is_multi_region_trail` is undefined and (2) `is_multi_region_trail` is set to false. Observe the following implementation as an example and check the Guidelines below.

```
package Cx

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	object.get(cloudtrail, "is_multi_region_trail", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "CloudTrail Multi Region is defined",
		"keyActualValue": "CloudTrail Multi Region is undefined",
	}
}

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	cloudtrail.is_multi_region_trail == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudtrail[%s].is_multi_region_trail", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "CloudTrail Multi Region is set to true",
		"keyActualValue": "CloudTrail Multi Region is set to false",
	}
}
```

👨‍💻 **Metadata File**

Observe the following metadata.json example and check the Guidelines below for more detailed information.

```
{
  "id": "8173d5eb-96b5-4aa6-a71b-ecfa153c123d",
  "queryName": "CloudTrail Multi Region Disabled",
  "severity": "MEDIUM",
  "category": "Observability",
  "descriptionText": "Check if MultiRegion is Enabled",
  "descriptionUrl": "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail#is_multi_region_trail",
  "platform": "Terraform"
}

```
👨‍💻 **Test Folder**

The positive cases should present the breaking points of the vulnerability. Continuing with the example, we should display two resources: one without the `is_multi_region_trail` defined (positive1) and another with the `is_multi_region_trail` set to false (positive2). 

```
resource "aws_cloudtrail" "positive1" {
  name                          = "npositive_1"
  s3_bucket_name                = "bucketlog_1"
}

resource "aws_cloudtrail" "positive2" {
  name                          = "npositive_2"
  s3_bucket_name                = "bucketlog_2"
  is_multi_region_trail         = false
}

```

The negative case(s) should present the remediation/best practice (a sample with the `is_multi_region_trail` set to true).

```
resource "aws_cloudtrail" "negative1" {
  name                          = "negative"
  s3_bucket_name                = "bucketlog"
  is_multi_region_trail         = true
}
```

The positive expected result should present where the positive(s) file(s) break(s) the vulnerability (in line 2 (positive1) and line 10 (positive2)).

```
[
  {
    "queryName": "CloudTrail Multi Region Disabled",
    "severity": "MEDIUM",
    "line": 2
  },
  {
    "queryName": "CloudTrail Multi Region Disabled",
    "severity": "MEDIUM",
    "line": 10
  }
]

```


#### Testing

For a query to be considered complete, it must be compliant with at least one positive and one negative test case. To run the unit tests you can run this command:

```bash
make test
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


Filling query.rego:

- `documentId` id of the sample where the vulnerability occurs
- `searchKey` should indicate where the breaking point occurs in the sample
- `issueType` pick one of the following:
    - IncorrectValue
    - MissingAttribute
    - RedundantAttribute
- `keyExpectedValue` should explain the expected value
- `keyActualValue`   should explain the actual value detected
