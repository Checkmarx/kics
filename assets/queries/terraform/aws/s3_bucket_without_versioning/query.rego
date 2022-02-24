package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

#default of versioning is false
CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "versioning")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is set to true",
		"keyActualValue": "'versioning' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is set to true",
		"keyActualValue": "'versioning' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

#default of enabled is false
CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket.versioning, "enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.enabled' is set to true",
		"keyActualValue": "'versioning.enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	not common_lib.valid_key(module[keyToCheck], "enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.enabled' is set to true",
		"keyActualValue": "'versioning.enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name, "versioning"], []),
	}
}

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)
	
	bucket := input.document[i].resource.aws_s3_bucket[name]
	bucket.versioning.enabled != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' is set to true",
		"keyActualValue": "'versioning.enabled' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", "enabled"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	module[keyToCheck].enabled != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].versioning.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' is set to true",
		"keyActualValue": "'versioning.enabled' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "versioning", "enabled"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	bucket_versioning := input.document[i].resource.aws_s3_bucket_versioning[name]
	split(bucket_versioning.bucket, ".")[1] == bucketName
	bucket_versioning.versioning_configuration.status == "Suspended"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning_configuration.status' is set to 'Enabled'",
		"keyActualValue": "'versioning_configuration.status' is set to 'Suspended'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "status"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[i].resource.aws_s3_bucket[bucketName]
	
	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_versioning")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' has 'aws_s3_bucket_versioning' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'aws_s3_bucket_versioning' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}
