## Query Categories

You can find a list of queries, and their associated categories here: [https://docs.kics.io/latest/queries/all-queries/](https://docs.kics.io/latest/queries/all-queries/)

The category list is:

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
- Structure and Semantics
- Supply-Chain

## Queries

KICS queries are written in OPA (Rego).

```rego
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

#### Anatomy

The anatomy of a query is straightforward. It builds up a policy and defines the result.

The **policy** builds the pattern that breaks the *security* of the infrastructure code and which the query is looking for.

The **result** defines the specific data used to present the *vulnerability* in the infrastructure code.


#### Metadata

Each query has a metadata.json companion file with all the relevant information about the *vulnerability*, including
the severity, category and its description. Additional fields can be found on queries metadata file, such as descriptionID, cloudProvider or cwe.

For example, the JSON code above is the metadata corresponding to the query in the beginning of this document.
```json
{
  "id": "5738faf3-3fe6-4614-a93d-f0003242d4f9",
  "queryName": "All Users Group Gets Read Access",
  "severity": "HIGH",
  "category": "Identity and Access Management",
  "descriptionText": "It's not recommended to allow read access for all user groups.",
  "descriptionUrl": "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
  "platform": "Terraform"
}
```

#### Organization

Filesystem-wise, KICS queries are organized per IaC technology or tool/platform (e.g., terraform, k8s, dockerfile, etc.) and grouped under provider (e.g., aws, gcp, azure, etc.) when applicable.

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

Also, a query can contains multiples positive and negative files, but all cases files names must start with negative or positive and
each positive file must be referenced on `positive_expected_result.json`, as shown below:

```json
[
  {
    "queryName": "ELB Sensitive Port Is Exposed To Entire Network",
    "severity": "HIGH",
    "line": 37,
    "fileName": "positive1.yaml"
  },
  {
    "queryName": "ELB Sensitive Port Is Exposed To Entire Network",
    "severity": "HIGH",
    "line": 22,
    "fileName": "positive2.yaml"
  }
]
```
And the file tree should be as follows:

```none
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

##### Folder-Based Test Case (Optional)

Test cases can optionally be organized into folders, which is useful when multiple resource files are needed for a single case.
Each folder is treated as a single unit representing either a positive or a negative case. Positive cases must include their own `positive_expected_result.json` file containing the expected results.
Other than the `positive_expected_result.json` file, every file inside the folder must start with the folder’s name.
The file tree for a query can be extended to:
```none
- <technology>/
    |- <provider>/
    |    |- <queryfolder>/
    |    |    |- test/
    |    |    |    |- positive<.ext>
    |    |    |    |- negative<.ext>
    |    |    |    |- positive_expected_result.json
    |    |    |    |- positive/ (= <folder_name>/)
    |    |    |    |    |- <folder_name><.ext>
    |    |    |    |    |- positive_expected_result.json
    |    |    |    |- negative/ (= <folder_name>/)
    |    |    |    |    |- <folder_name><.ext>
    |    |    |- metadata.json
    |    |    |- query.rego
```

A query containing all the cases could look like:
```none
- <technology>/
    |- <provider>/
    |    |- <queryfolder>/
    |    |    |- test/
    |    |    |    |- positive1<.ext>
    |    |    |    |- positive2<.ext>
    |    |    |    |- negative1<.ext>
    |    |    |    |- negative2<.ext>
    |    |    |    |- positive_expected_result.json
    |    |    |    |- positive3/
    |    |    |    |    |- positive3_1<.ext>
    |    |    |    |    |- positive3_2<.ext>
    |    |    |    |    |- positive_expected_result.json
    |    |    |    |- negative3/
    |    |    |    |    |- negative3_1<.ext>
    |    |    |    |    |- negative3_2<.ext>
    |    |    |- metadata.json
    |    |    |- query.rego
```

#### Query Dependencies

If you want to use the functions defined in your own library, you should use the flag `-b` to indicate the directory where the libraries are placed. The functions need to be grouped by platform and the library name should follow the following format: `<platform>.rego`. It doesn't matter your directory structure. In other words, for example, if you want to indicate a directory that contains a library for your terraform queries, you should group your functions (used in your terraform queries) in a file named `terraform.rego` wherever you want.

#### Default Queries

To use KICS default queries add the KICS_QUERIES_PATH environmental variable to your shell profile, e.g:

```
echo 'export KICS_QUERIES_PATH=/usr/local/opt/kics/share/kics/assets/queries' >> ~/.zshrc
```

#### Custom Queries

You can provide your own path to the queries directory with `-q` CLI option (see CLI Options section below), otherwise the default directory will be used. The default _./assets/queries_ is built-in in the image. You can use this to provide a path to your own custom queries. Check [create a new query guide](creating-queries.md) to learn how to define your own queries.

#### Password and Secrets

Since the Password and Secrets mechanism uses generic regexes, we advise you to tweak the rules of the secret to your context. Please, see the [Password and Secrets documentation](https://github.com/Checkmarx/kics/blob/master/docs/secrets.md#new-rules-addition) to know how you can use your own rules.

---

**Note**: KICS does not execute scan by default as of [version 1.3.0](https://github.com/Checkmarx/kics/releases/tag/v1.3.0).

**Note**: KICS deprecated the availability of binaries in the GitHub releases assets as of [version 1.5.2](https://github.com/Checkmarx/kics/releases/tag/v1.5.2), it is advised to update all systems (pipelines, integrations, etc.) to use the [KICS Docker Images](https://hub.docker.com/r/checkmarx/kics).
