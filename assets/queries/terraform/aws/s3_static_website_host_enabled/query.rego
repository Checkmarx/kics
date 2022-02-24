package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	resource := input.document[i].resource.aws_s3_bucket[name]
	count(resource.website) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_s3_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_s3_bucket[%s].website doesn't have static websites inside", [name]),
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
		"searchKey": sprintf("module[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' doesn't have static websites inside",
		"keyActualValue": "'website' does have static websites inside",
		"searchLine": common_lib.build_search_line(["module", name, "website"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[i].resource.aws_s3_bucket[bucketName]
	
	terra_lib.has_target_resource(bucketName, "aws_s3_bucket_website_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' does not have 'aws_s3_bucket_website_configuration' associated",
		"keyActualValue": "'aws_s3_bucket' has 'aws_s3_bucket_website_configuration' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}
