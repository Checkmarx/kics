package Cx

import data.generic.common as common_lib

#default of versioning is false
CxPolicy[result] {
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
