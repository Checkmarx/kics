## [Terraform] Bill Of Materials

This feature uses Rego queries to extract a list of used Terraform resources along with its metadata in the scanned IaC.

Find the existing queries under: [assets/queries/terraform/aws_bom](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/aws_bom)

BoM queries extracts metadata about the resources and organizes it in the following structure:

```go
billOfMaterialsRequiredFields := map[string]bool{
    "acl":                    false,
    "policy":                 false,
    "resource_accessibility": true,
    "resource_category":      true,
    "resource_encryption":    true,
    "resource_engine":        false,
    "resource_name":          true,
    "resource_type":          true,
    "resource_vendor":        true,
}
```

Observe more detailed information about it in the table below.

|        **Field**       |                                                                                                                                                      **Possible Values**                                                                                                                                                     | **Required** |                               **Resources**                              |     **Type**    |
|:----------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------:|:------------------------------------------------------------------------:|:---------------:|
|           acl          |                                                                                         private,<br /> public-read,<br /> public-read-write,<br /> aws-exec-read,<br /> authenticated-read,<br /> bucket-owner-read,<br /> bucket-owner-full-control,<br />  log-delivery-write                                                                                        |      No      |                              `aws_s3_bucket`                             |      string     |
|         policy         |                                                                                                                                                        policy content (in case `resource_accessibility` equals hasPolicy)                                                                                                                                                        |      No      | `aws_efs_file_system`,<br /> `aws_s3_bucket`,<br /> `aws_sns_topic`,<br /> `aws_sqs_queue` | JSON marshalled |
| resource_accessibility |                                                                                                                                              public, private, hasPolicy or unknown for `aws_ebs_volume`, `aws_efs_file_system`, `aws_mq_broker`, `aws_msk_cluster`, `aws_s3_bucket`,  `aws_sns_topic`, and `aws_sqs_queue` <br /> <br /> at least one security group associated with the elasticache is unrestricted, all security groups associated with the elasticache are restricted or unknown for `aws_elasticache_cluster`                                                                                                                                              |      Yes     |                                    all                                   |      string     |
|    resource_category   |                                         In Memory Data Structure for `aws_elasticache_cluster`<br /><br />  Messaging for `aws_sns_topic`<br /><br />  Queues for `aws_mq_broker` and `aws_sqs_queue`<br /><br />  Storage for `aws_ebs_volume`, `aws_efs_file_system`, and `aws_s3_bucket`<br /><br />  Streaming for `aws_msk_cluster`                                         |      Yes     |                                    all                                   |      string     |
|   resource_encryption  |                                                                                                                                                encrypted,<br />  unencrypted,<br />  unknown                                                                                                                                               |      Yes     |                                    all                                   |      string     |
|     resource_engine    |                                                                                                              memcached, redis or unknown for `aws_elasticache_cluster`<br /><br />  ActiveMQ or RabbitMQ for `aws_mq_broker`                                                                                                              |      No      |               `aws_elasticache_cluster`, <br /> `aws_mq_broker`              |      string     |
|      resource_name     |                                                                                                                            anything (if the name is defined),<br /> unknown (if the name is not defined)                                                                                                                           |      Yes     |                                    all                                   |      string     |
|      resource_type     | aws_ebs_volume for `aws_ebs_volume`,<br /> aws_efs_file_system for `aws_efs_file_system`,<br /> aws_elasticache_cluster for `aws_elasticache_cluster`,<br /> aws_mq_broker for `aws_mq_broker`,<br /> aws_msk_cluster for `aws_msk_cluster`,<br /> aws_s3_bucket for `aws_s3_bucket`,<br /> aws_sns_topic for `aws_sns_topic`, aws_sqs_queue for `aws_sqs_queue` |      Yes     |                                    all                                   |      string     |
|     resource_vendor    |                                                                                                                                                              AWS                                                                                                                                                             |      Yes     |                                    all                                   |      string     |


### BoM query example

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
