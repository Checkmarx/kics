package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# version before TF AWS 4.0
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	sse := bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

	check_master_key(sse)
	sse.sse_algorithm != "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' should be AES256 when key is null",
		"keyActualValue": sprintf("'sse_algorithm' is %s when key is null", [sse.sse_algorithm]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "sse_algorithm"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "server_side_encryption_configuration")

	ssec := module[keyToCheck]
	algorithm := ssec.rule.apply_server_side_encryption_by_default

	check_master_key(algorithm)
	algorithm.sse_algorithm != "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' should be AES256 when key is null",
		"keyActualValue": sprintf("'sse_algorithm' is %s when key is null", [algorithm.sse_algorithm]),
		"searchLine": common_lib.build_search_line(["module", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "sse_algorithm"], []),
	}
}

# version before TF AWS 4.0
CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	ssec := resource.server_side_encryption_configuration
	algorithm := ssec.rule.apply_server_side_encryption_by_default

	not check_master_key(algorithm)
	algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' should be null when algorithm is 'AES256'",
		"keyActualValue": "'kms_master_key_id'is not null when algorithm is 'AES256'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "kms_master_key_id"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "server_side_encryption_configuration")

	ssec := module[keyToCheck]
	algorithm := ssec.rule.apply_server_side_encryption_by_default

	not check_master_key(algorithm)
	algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' should be null when algorithm is 'AES256'",
		"keyActualValue": "'kms_master_key_id'is not null when algorithm is 'AES256'",
		"searchLine": common_lib.build_search_line(["module", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "kms_master_key_id"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "server_side_encryption_configuration")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'server_side_encryption_configuration' should be defined and not null",
		"keyActualValue": "'server_side_encryption_configuration' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[bucketName]

	not is_associated(bucketName, input.document[i])
	not tf_lib.has_target_resource(bucketName, "aws_s3_bucket_server_side_encryption_configuration") # version after TF AWS 4.0
	not common_lib.valid_key(bucket, "server_side_encryption_configuration") # version before TF AWS 4.0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", bucketName),
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' to have 'server_side_encryption_configuration' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'server_side_encryption_configuration' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]

	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName
	not common_lib.valid_key(sse.rule, "apply_server_side_encryption_by_default")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_server_side_encryption_configuration",
		"resourceName": tf_lib.get_resource_name(sse, name),
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'apply_server_side_encryption_by_default' should be defined and not null",
		"keyActualValue": "'apply_server_side_encryption_by_default' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]

	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName
	algorithm := sse.rule.apply_server_side_encryption_by_default
	not check_master_key(algorithm)
	algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_server_side_encryption_configuration",
		"resourceName": tf_lib.get_resource_name(sse, name),
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' should be null when algorithm is 'AES256'",
		"keyActualValue": "'kms_master_key_id' is not null when algorithm is 'AES256'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule", "apply_server_side_encryption_by_default", "kms_master_key_id"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]

	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName

	rule := sse.rule.apply_server_side_encryption_by_default
	check_master_key(rule)
	rule.sse_algorithm != "AES256"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_server_side_encryption_configuration",
		"resourceName": tf_lib.get_resource_name(sse, name),
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' should be AES256 when key is null",
		"keyActualValue": sprintf("'sse_algorithm' is %s when key is null", [rule.sse_algorithm]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule", "apply_server_side_encryption_by_default", "sse_algorithm"], []),
	}
}

check_master_key(assed) {
	not common_lib.valid_key(assed, "kms_master_key_id")
} else {
	common_lib.emptyOrNull(assed.kms_master_key_id)
}

is_associated(aws_s3_bucket_name, doc) {
	[_, value] := walk(doc)
	sse_configurations := value.aws_s3_bucket_server_side_encryption_configuration[_]
	contains(sse_configurations.bucket, sprintf("aws_s3_bucket.%s", [aws_s3_bucket_name]))
}
