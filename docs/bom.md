## Bill Of Materials

This feature uses Rego queries to extract a list of used Terraform resources along with its metadata in the scanned IaC.

Find the existing queries under: [assets/queries/terraform/aws_bom](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws_bom)

BoM queries extracts metadata about the resources and organizes it in the following structure:

```go
billOfMaterialsRequiredFields := map[string]bool{
    "resource_type":          true,
    "resource_name":          true,
    "resource_engine":        false,
    "resource_accessibility": true,
    "resource_vendor":        true,
    "resource_category":      true,
}
```

After extracting the information the query stores the stringified JSON structure inside the `value` field in the `result`:

```rego
CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": get_accessibility(bucket_resource, name),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"value": json.marshal(bom_output),
	}
}
```

### Results

Results will be found in the [JSON](results.md) output and placed separately under `bill_of_materials` key:

```json
{
    // etc...
    "bill_of_materials": [
        {
            "query_name": "BOM - MSK",
            "query_id": "051f2063-2517-4295-ad8e-ba88c1bf5cfc",
            "query_url": "https://kics.io",
            "severity": "TRACE",
            "platform": "Terraform",
            "category": "Bill Of Materials",
            "description": "A list of MSK resources specified. Amazon Managed Streaming for Apache Kafka (Amazon MSK) is a fully managed service that enables you to build and run applications that use Apache Kafka to process streaming data.",
            "description_id": "cf7ae008",
            "files": [
                {
                    "file_name": "sample1.tf",
                    "similarity_id": "9c1bd86b2367fd748ed66a86f72d637231be6e4ec04d68dd10a61f233187b777",
                    "line": 1,
                    "issue_type": "BillOfMaterials",
                    "search_key": "aws_msk_cluster[example_msk1]",
                    "search_line": 0,
                    "search_value": "",
                    "expected_value": "",
                    "actual_value": "",
                    "value": "{\"resource_accessibility\":\"encrypted\",\"resource_category\":\"Queues\",\"resource_name\":\"example\",\"resource_type\":\"aws_msk_cluster\",\"resource_vendor\":\"AWS\"}"
                }
            ]
        },
    ]
}
```

To enable bill-of-materials in the results use the `--bom` flag.

**NOTE** Bill of Materials queries should always have:
- `severity: "TRACE"`
- `category: "Bill Of Materials"`
- `issue_type: "BillOfMaterials"`
