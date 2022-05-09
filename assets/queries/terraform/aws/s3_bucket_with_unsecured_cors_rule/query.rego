package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

# version before TF AWS 4.0
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]

	rule := bucket.cors_rule
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' to not allow all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "cors_rule"], []),
	}
}

# version before TF AWS 4.0
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]

	rule := bucket.cors_rule[idx]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' to not allow all methods, all headers or several origins",
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
		"keyExpectedValue": "'cors_rule' to not allow all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, ruleIdx], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {	
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	cors_configuration := input.document[i].resource.aws_s3_bucket_cors_configuration[name]
	split(cors_configuration.bucket, ".")[1] == bucketName
	rule := cors_configuration.cors_rule
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' to not allow all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_cors_configuration", name, "cors_rule"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]
	
	cors_configuration := input.document[i].resource.aws_s3_bucket_cors_configuration[name]
	split(cors_configuration.bucket, ".")[1] == bucketName
	rule := cors_configuration.cors_rule[idx]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' to not allow all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_cors_configuration", name, "cors_rule", idx], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {	
	resource := input.document[i].resource.aws_s3_bucket[bucketName]
	not terra_lib.has_target_resource(bucketName, "aws_s3_bucket_cors_configuration")
	not common_lib.valid_key(resource, "cors_rule")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' to have 'cors' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'cors' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}
