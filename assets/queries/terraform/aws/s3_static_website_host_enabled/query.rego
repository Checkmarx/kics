package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# version before TF AWS 4.0
CxPolicy[result] {

	resource := input.document[i].resource.aws_s3_bucket[name]
	count(resource.website) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("resource.aws_s3_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_s3_bucket[%s].website to not have static websites inside", [name]),
		"keyActualValue": sprintf("resource.aws_s3_bucket[%s].website does have static websites inside", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "website"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "website")
	
	count(module[keyToCheck]) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' to not have static websites inside",
		"keyActualValue": "'website' does have static websites inside",
		"searchLine": common_lib.build_search_line(["module", name, "website"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {	
	resource := input.document[i].resource.aws_s3_bucket[bucketName]
	
	tf_lib.has_target_resource(bucketName, "aws_s3_bucket_website_configuration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", bucketName),
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' to not have 'aws_s3_bucket_website_configuration' associated",
		"keyActualValue": "'aws_s3_bucket' has 'aws_s3_bucket_website_configuration' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}
