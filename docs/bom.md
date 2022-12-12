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
|         policy         |                                                                                                                                                        policy content (in case `resource_accessibility` equals hasPolicy)                                                                                                                                                        |      No      | `aws_efs_file_system`,<br /> `aws_s3_bucket`,<br /> `aws_sns_topic`,<br /> `aws_sqs_queue`,<br /> `aws_dynamodb_table`| JSON marshalled |
| resource_accessibility |                                                                                                                                              public, private, hasPolicy or unknown for <br /> `aws_ebs_volume`,<br /> `aws_efs_file_system`,<br /> `aws_mq_broker`,<br /> `aws_msk_cluster`,<br /> `aws_s3_bucket`,<br />  `aws_sns_topic`,<br /> `aws_sqs_queue`,<br /> `aws_db_instance`, <br /> `aws_rds_cluster_instance`,<br /> `aws_kinesis_stream`,<br /> and `aws_dynamodb_table` <br /> <br /> at least one security group associated with the elasticache is unrestricted, all security groups associated with the elasticache are restricted or unknown for `aws_elasticache_cluster`                                                                                                                                              |      Yes     |                                    all                                   |      string     |
|    resource_category   |                                         In Memory Data Structure for `aws_elasticache_cluster`<br /><br />  Messaging for `aws_sns_topic`<br /><br />  Queues for `aws_mq_broker` and `aws_sqs_queue`<br /><br />  Storage for `aws_ebs_volume`, `aws_efs_file_system`, `aws_s3_bucket`,<br /> `aws_db_instance`, <br /> `aws_rds_cluster_instance`, and `aws_dynamodb_table`  <br /><br />  Streaming for `aws_msk_cluster` and `aws_kinesis_stream`                                       |      Yes     |                                    all                                   |      string     |
|   resource_encryption  |                                                                                                                                                encrypted,<br />  unencrypted,<br />  unknown                                                                                                                                               |      Yes     |                                    all                                   |      string     |
|     resource_engine    |                                                                                                              memcached, redis or unknown for `aws_elasticache_cluster`<br /><br />  ActiveMQ or RabbitMQ for `aws_mq_broker` <br /><br /> parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html) or unknown for <br /> `aws_db_instance`, and <br /> `aws_rds_cluster_instance`                                                                                                             |      No      |               `aws_elasticache_cluster`, <br /> `aws_mq_broker`,<br /> `aws_db_instance`,<br /> `aws_rds_cluster_instance`             |      string     |
|      resource_name     |                                                                                                                            anything (if the name is defined),<br /> unknown (if the name is not defined)                                                                                                                           |      Yes     |                                    all                                   |      string     |
|      resource_type     | aws_ebs_volume for `aws_ebs_volume`,<br /> aws_efs_file_system for `aws_efs_file_system`,<br /> aws_elasticache_cluster for `aws_elasticache_cluster`,<br /> aws_mq_broker for `aws_mq_broker`,<br /> aws_msk_cluster for `aws_msk_cluster`,<br /> aws_s3_bucket for `aws_s3_bucket`,<br /> aws_sns_topic for `aws_sns_topic`,<br /> aws_sqs_queue for `aws_sqs_queue` <br /> aws_db_instance for `aws_db_instance`,<br /> aws_rds_cluster_instance for `aws_rds_cluster_instance`,<br /> aws_dynamodb_table for `aws_dynamodb_table`, <br /> aws_kinesis_stream for `aws_kinesis_stream`  |      Yes     |                                    all                                   |      string     |
|     resource_vendor    |                                                                                                                                                              AWS                                                                                                                                                             |      Yes     |                                    all                                   |      string     |


### BoM query example

```rego
CxPolicy[result] {
	bucket_resource := input.document[i].resource.aws_s3_bucket[name]

	info := get_accessibility(bucket_resource, name)

	bom_output = {
		"resource_type": "aws_s3_bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": info.accessibility,
		"resource_encryption": common_lib.get_encryption_if_exists(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource),
	}

	final_bom_output = common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"value": json.marshal(final_bom_output),
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
			"query_name": "BOM - AWS S3 Buckets",
			"query_id": "2d16c3fb-35ba-4ec0-b4e4-06ee3cbd4045",
			"query_url": "https://kics.io",
			"severity": "TRACE",
			"platform": "Terraform",
			"cloud_provider": "AWS",
			"category": "Bill Of Materials",
			"description": "A list of S3 resources found. Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance.",
			"description_id": "0bdf2341",
			"files": [
				{
					"file_name": "assets\\queries\\terraform\\aws_bom\\s3_bucket\\test\\positive8.tf",
					"similarity_id": "aaf7959a055b67a35369c2b02aad327f28e85cca02e2daff3d3e40e2b460f36a",
					"line": 1,
					"issue_type": "BillOfMaterials",
					"search_key": "aws_s3_bucket[positive8]",
					"search_line": 0,
					"search_value": "",
					"expected_value": "",
					"actual_value": "",
					"value": "{\"acl\":\"public-read\",\"policy\":{\"Id\":\"MYBUCKETPOLICY\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"IpAddress\":{\"aws:SourceIp\":\"8.8.8.8/32\"}},\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"arn:aws:iam::123456789012:root\",\"arn:aws:iam::555555555555:root\"]},\"Resource\":\"arn:aws:s3:::my_tf_test_bucket/*\",\"Sid\":\"IPAllow\"}],\"Version\":\"2012-10-17\"},\"resource_accessibility\":\"hasPolicy\",\"resource_category\":\"Storage\",\"resource_encryption\":\"encrypted\",\"resource_name\":\"my-tf-test-bucket\",\"resource_type\":\"aws_s3_bucket\",\"resource_vendor\":\"AWS\"}"
				}
			]
		}
	]
}
```

To enable bill-of-materials in the results use the `--bom` flag.

**NOTE** Bill of Materials queries should always have:
- `severity: "TRACE"`
- `category: "Bill Of Materials"`
- `issue_type: "BillOfMaterials"`


## [CloudFormation] Bill Of Materials

This feature uses Rego queries to extract a list of used CloudFormation resources along with its metadata in the scanned IaC.

Find the existing queries under: [assets/queries/cloudFormation/aws_bom](https://github.com/Checkmarx/kics/tree/master/assets/queries/cloudFormation/aws_bom)

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
|           acl          |                                                                                         Private,<br /> PublicRead,<br /> PublicReadWrite,<br /> AuthenticatedRead,<br /> LogDeliveryWrite,<br /> BucketOwnerRead,<br /> BucketOwnerFullControl,<br /> AwsExecRead                                                                                        |      No      |                              `AWS::S3::Bucket`                             |      string     |
|         policy         |                                                                                                                                                        policy content (in case `resource_accessibility` equals hasPolicy)                                                                                                                                                        |      No      | `AWS::EFS::FileSystem`,<br /> `AWS::S3::Bucket`,<br /> `AWS::SNS::Topic`,<br /> `AWS::SQS::Queue`,<br /> `AWS::DynamoDB::Table`| JSON marshalled |
| resource_accessibility |                                                                                                                                              public, private, hasPolicy or unknown for <br />`AWS::EC2::Volume`,<br />`AWS::EFS::FileSystem`,<br />`AWS::AmazonMQ::Broker`,<br />`AWS::MSK::Cluster`,<br />`AWS::S3::Bucket`, <br />`AWS::SNS::Topic`,<br />`AWS::SQS::Queue`,<br />`AWS::RDS::DBInstance`, <br />`AWS::Kinesis::Stream`, <br />`AWS::DynamoDB::Table`, <br /> and `AWS::Cassandra::Table` <br /> <br /> at least one security group associated with the elasticache is unrestricted, all security groups associated with the elasticache are restricted or unknown for `AWS::ElastiCache::CacheCluster`                                                                                                                                              |      Yes     |                                    all                                   |      string     |
|    resource_category   |                                         In Memory Data Structure for `AWS::ElastiCache::CacheCluster`<br /><br />  Messaging for `AWS::SNS::Topic`<br /><br />  Queues for `AWS::AmazonMQ::Broker` and `AWS::SQS::Queue`<br /><br />  Storage for `AWS::EC2::Volume`, `AWS::EFS::FileSystem`, `AWS::S3::Bucket`, `AWS::RDS::DBInstance`, `AWS::DynamoDB::Table`, `AWS::Cassandra::Table`, and `AWS::Kinesis::Stream`<br /><br />  Streaming for `AWS::MSK::Cluster`                                         |      Yes     |                                    all                                   |      string     |
|   resource_encryption  |                                                                                                                                                encrypted,<br />  unencrypted,<br />  unknown                                                                                                                                               |      Yes     |                                    all                                   |      string     |
|     resource_engine    |                                                                                                              memcached, redis or unknown for `AWS::ElastiCache::CacheCluster`<br /><br />  ACTIVEMQ or RABBITMQ for `AWS::AmazonMQ::Broker` <br /><br /> aurora, aurora-mysql, aurora-postgresql, mariadb, mysql, oracle-ee, oracle-ee-cdb, oracle-se2, oracle-se2-cdb, postgres, sqlserver-ee, sqlserver-se, sqlserver-ex, sqlserver-web or unknown for `AWS::RDS::DBInstance`                                                                                                             |      No      |               `AWS::ElastiCache::CacheCluster`, <br /> `AWS::AmazonMQ::Broker`,<br /> `AWS::RDS::DBInstance`              |      string     |
|      resource_name     |                                                                                                                            anything (if the name is defined),<br /> unknown (if the name is not defined)                                                                                                                           |      Yes     |                                    all                                   |      string     |
|      resource_type     | AWS::EC2::Volume for `AWS::EC2::Volume`,<br /> AWS::EFS::FileSystem for `AWS::EFS::FileSystem`,<br /> AWS::ElastiCache::CacheCluster for `AWS::ElastiCache::CacheCluster`,<br /> AWS::AmazonMQ::Broker for `AWS::AmazonMQ::Broker`,<br /> AWS::MSK::Cluster for `AWS::MSK::Cluster`,<br /> AWS::S3::Bucket for `AWS::S3::Bucket`,<br /> AWS::SNS::Topic for `AWS::SNS::Topic`, <br/>AWS::SQS::Queue for `AWS::SQS::Queue`,<br/> AWS::RDS::DBInstance for `AWS::RDS::DBInstance`,<br /> AWS::DynamoDB::Table for `AWS::DynamoDB::Table`,<br /> AWS::Kinesis::Stream for `AWS::Kinesis::Stream`, <br /> AWS::Cassandra::Table for `AWS::Cassandra::Table`|      Yes     |                                    all                                   |      string     |
|     resource_vendor    |                                                                                                                                                              AWS                                                                                                                                                             |      Yes     |                                    all                                   |      string     |


### BoM query example
```
CxPolicy[result] {
	document := input.document
	bucket_resource := document[i].Resources[name]
	bucket_resource.Type == "AWS::S3::Bucket"

	info := get_resource_accessibility(bucket_resource, name)

	bom_output = {
		"resource_type": "AWS::S3::Bucket",
		"resource_name": get_bucket_name(bucket_resource),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(bucket_resource),
		"resource_vendor": "AWS",
		"resource_category": "Storage",
		"acl": get_bucket_acl(bucket_resource),
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
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
			"query_name": "BOM - AWS S3 Buckets",
			"query_id": "b5d6a2e0-8f15-4664-bd5b-68ec5c9bab83",
			"query_url": "https://kics.io",
			"severity": "TRACE",
			"platform": "CloudFormation",
			"cloud_provider": "AWS",
			"category": "Bill Of Materials",
			"description": "A list of S3 resources found. Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance.",
			"description_id": "a46851fb",
			"files": [
				{
					"file_name": "positive2.json",
					"similarity_id": "a307e0f377932f42880de350fc69f83084aa8451a2e1e2a37cc97fc4eae7cf94",
					"line": 5,
					"issue_type": "BillOfMaterials",
					"search_key": "Resources.JenkinsArtifacts03",
					"search_line": 0,
					"search_value": "",
					"expected_value": "",
					"actual_value": "",
					"value": "{\"acl\":\"BucketOwnerFullControl\",\"resource_accessibility\":\"unknown\",\"resource_category\":\"Storage\",\"resource_encryption\":\"unencrypted\",\"resource_name\":\"jenkins-artifacts\",\"resource_type\":\"AWS::S3::Bucket\",\"resource_vendor\":\"AWS\"}"
				},
				{
					"file_name": "positive1.yaml",
					"similarity_id": "24a0036d2e94676f33c505c5cfd6686ef414072a14e576b08283e9a77596f7eb",
					"line": 4,
					"issue_type": "BillOfMaterials",
					"search_key": "Resources.MyBucket",
					"search_line": 0,
					"search_value": "",
					"expected_value": "",
					"actual_value": "",
					"value": "{\"acl\":\"BucketOwnerFullControl\",\"policy\":{\"Statement\":[{\"Action\":[\"s3:GetObject\"],\"Condition\":{\"StringLike\":{\"aws:Referer\":[\"http://www.example.com/*\",\"http://example.net/*\"]}},\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":[\"\",{\"playbooks\":[\"arn:aws:s3:::\",\"DOC-EXAMPLE-BUCKET\",\"/*\"]}]}],\"Version\":\"2012-10-17\"},\"resource_accessibility\":\"hasPolicy\",\"resource_category\":\"Storage\",\"resource_encryption\":\"encrypted\",\"resource_name\":\"jenkins-artifacts\",\"resource_type\":\"AWS::S3::Bucket\",\"resource_vendor\":\"AWS\"}"
				}
			]
		}
	]
}
```
