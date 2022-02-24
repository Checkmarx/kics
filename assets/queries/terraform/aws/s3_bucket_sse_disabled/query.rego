package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	bucket := input.document[i].resource.aws_s3_bucket[name]
	sse := bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

	check_master_key(sse)
	sse.sse_algorithm != "AES256"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' is AES256 when key is null",
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
		"searchKey": sprintf("module[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' is AES256 when key is null",
		"keyActualValue": sprintf("'sse_algorithm' is %s when key is null", [algorithm.sse_algorithm]),
		"searchLine": common_lib.build_search_line(["module", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "sse_algorithm"], []),
	}
}

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	resource := input.document[i].resource.aws_s3_bucket[name]
	ssec := resource.server_side_encryption_configuration
	algorithm := ssec.rule.apply_server_side_encryption_by_default

	not check_master_key(algorithm)
	algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' is null when algorithm is 'AES256'",
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
		"searchKey": sprintf("module[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' is null when algorithm is 'AES256'",
		"keyActualValue": "'kms_master_key_id'is not null when algorithm is 'AES256'",
		"searchLine": common_lib.build_search_line(["module", name, "server_side_encryption_configuration", "rule", "apply_server_side_encryption_by_default", "kms_master_key_id"], []),
	}
}

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)
	
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "server_side_encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'server_side_encryption_configuration' is defined and not null",
		"keyActualValue": "'server_side_encryption_configuration' is undefined or null",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "server_side_encryption_configuration")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'server_side_encryption_configuration' is defined and not null",
		"keyActualValue": "'server_side_encryption_configuration' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[i].resource.aws_s3_bucket[bucketName]
	
	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_server_side_encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' has 'aws_s3_bucket_server_side_encryption_configuration' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'aws_s3_bucket_server_side_encryption_configuration' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName
	not common_lib.valid_key(sse.rule, "apply_server_side_encryption_by_default")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'apply_server_side_encryption_by_default' is defined and not null",
		"keyActualValue": "'apply_server_side_encryption_by_default' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName
	algorithm := sse.rule.apply_server_side_encryption_by_default
	not check_master_key(algorithm)
	algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule.apply_server_side_encryption_by_default.kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' is null when algorithm is 'AES256'",
		"keyActualValue": "'kms_master_key_id' is not null when algorithm is 'AES256'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule", "apply_server_side_encryption_by_default", "kms_master_key_id"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)

	input.document[_].resource.aws_s3_bucket[bucketName]

	sse := input.document[i].resource.aws_s3_bucket_server_side_encryption_configuration[name]
	split(sse.bucket, ".")[1] == bucketName

	rule := sse.rule.apply_server_side_encryption_by_default
	check_master_key(rule)
	rule.sse_algorithm != "AES256"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_server_side_encryption_configuration[%s].rule.apply_server_side_encryption_by_default.sse_algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'sse_algorithm' is AES256 when key is null",
		"keyActualValue": sprintf("'sse_algorithm' is %s when key is null", [rule.sse_algorithm]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_server_side_encryption_configuration", name, "rule", "apply_server_side_encryption_by_default", "sse_algorithm"], []),
	}
}

check_master_key(assed) {
	not common_lib.valid_key(assed, "kms_master_key_id")
} else {
	common_lib.emptyOrNull(assed.kms_master_key_id)
}
