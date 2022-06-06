package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	# version before TF AWS 4.0
	not common_lib.valid_key(bucket, "lifecycle_rule")
	not common_lib.valid_key(bucket, "versioning")
	
	# version after TF AWS 4.0
	not terra_lib.has_target_resource(name, "aws_s3_bucket_lifecycle_configuration")
	not terra_lib.has_target_resource(name, "aws_s3_bucket_versioning")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "versioning to be defined and not null",
		"keyActualValue": "versioning is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
	}
}

checkedFields = {
	"enabled",
	"mfa_delete"
}

# version before TF AWS 4.0
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "lifecycle_rule")
	not common_lib.valid_key(bucket.versioning, checkedFields[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' to be set to true", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is undefined or null", [checkedFields[j]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning"], []),
	}
}

# version before TF AWS 4.0
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "lifecycle_rule")
	bucket.versioning[checkedFields[j]] != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.%s", [name, checkedFields[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' to be set to true", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is set to false", [checkedFields[j]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", checkedFields[j]], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")

	not common_lib.valid_key(module, "lifecycle_rule")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' to be defined and not null",
		"keyActualValue": "'versioning' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
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
		"keyExpectedValue": sprintf("'%s' to be set to true", [checkedFields[c]]),
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
		"keyExpectedValue": sprintf("'%s' to be set to true", [checkedFields[c]]),
		"keyActualValue": sprintf("'%s' is set to false", [checkedFields[c]]),
		"searchLine": common_lib.build_search_line(["module", name, "versioning", checkedFields[c]], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]

	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_lifecycle_configuration")

	bucket_versioning := input.document[i].resource.aws_s3_bucket_versioning[name]
	split(bucket_versioning.bucket, ".")[1] == bucketName
	bucket_versioning.versioning_configuration.mfa_delete == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning_configuration.mfa_delete' to be set to 'Enabled'",
		"keyActualValue": "'versioning_configuration.mfa_delete' is set to 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "mfa_delete"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]

	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_lifecycle_configuration")

	bucket_versioning := input.document[i].resource.aws_s3_bucket_versioning[name]
	split(bucket_versioning.bucket, ".")[1] == bucketName
	bucket_versioning.versioning_configuration.status != "Enabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning_configuration.status' to be set to 'Enabled'",
		"keyActualValue": "'versioning_configuration.status' is set to 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "status"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	
	input.document[_].resource.aws_s3_bucket[bucketName]

	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_lifecycle_configuration")
	bucket_versioning := input.document[i].resource.aws_s3_bucket_versioning[name]
	split(bucket_versioning.bucket, ".")[1] == bucketName
	not common_lib.valid_key(bucket_versioning.versioning_configuration, "mfa_delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning_configuration.mfa_delete' to be defined and not null",
		"keyActualValue": "'versioning_configuration.mfa_delete' is undefined and not null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration"], []),
	}
}
