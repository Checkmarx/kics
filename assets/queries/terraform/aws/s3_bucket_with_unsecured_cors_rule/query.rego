package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	bucket := input.document[i].resource.aws_s3_bucket[name]

	rule := bucket.cors_rule
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "cors_rule"], []),
	}
}

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	bucket := input.document[i].resource.aws_s3_bucket[name]

	rule := bucket.cors_rule[idx]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "cors_rule", idx], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "cors_rule")
	rule := module.cors_rule[ruleIdx]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, ruleIdx], []),
	}
}


CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	cors_configuration := input.document[i].resource.aws_s3_bucket_cors_configuration[name]
	split(cors_configuration.bucket, ".")[1] == bucketName
	rule := cors_configuration.cors_rule
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_cors_configuration", name, "cors_rule"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	cors_configuration := input.document[i].resource.aws_s3_bucket_cors_configuration[name]
	split(cors_configuration.bucket, ".")[1] == bucketName
	rule := cors_configuration.cors_rule[idx]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_cors_configuration", name, "cors_rule", idx], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	input.document[i].resource.aws_s3_bucket[bucketName]
	
	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_cors_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' has 'aws_s3_bucket_cors_configuration' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'aws_s3_bucket_cors_configuration' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}
