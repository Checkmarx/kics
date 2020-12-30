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
  "id": "allUsers_group_gets_read_access",
  "queryName": "All Users Group Gets Read Access",
  "severity": "HIGH",
  "category": "IAM",
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
