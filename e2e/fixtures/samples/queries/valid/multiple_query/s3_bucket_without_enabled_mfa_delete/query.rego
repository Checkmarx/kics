package Cx

import data.generic.common as common_lib

checkedFields = {
	"enabled",
	"mfa_delete"
}

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "lifecycle_rule")
	not common_lib.valid_key(bucket.versioning, checkedFields[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be set to true", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is undefined or null", [checkedFields[j]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning"], []),
	}
}

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "lifecycle_rule")
	bucket.versioning[checkedFields[j]] != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.%s", [name, checkedFields[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to true", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is set to false", [checkedFields[j]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", checkedFields[j]], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	not common_lib.valid_key(module, "lifecycle_rule")
	not common_lib.valid_key(module[keyToCheck],  checkedFields[c])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be set to true", [checkedFields[c]]),
		"keyActualValue": sprintf("'%s' is undefined or null", [checkedFields[c]]),
		"searchLine": common_lib.build_search_line(["module", name, "versioning"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	not common_lib.valid_key(module, "lifecycle_rule")
	module[keyToCheck][checkedFields[c]] != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].versioning.%s", [name, checkedFields[c]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to true", [checkedFields[c]]),
		"keyActualValue": sprintf("'%s' is set to false", [checkedFields[c]]),
		"searchLine": common_lib.build_search_line(["module", name, "versioning", checkedFields[c]], []),
	}
}
