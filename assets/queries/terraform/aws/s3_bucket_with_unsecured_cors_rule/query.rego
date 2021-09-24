package Cx

import data.generic.common as common_lib

CxPolicy[result] {
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
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "cors_rule")
	rule := module.cors_rule
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cors_rule' does not allows all methods, all headers or several origins",
		"keyActualValue": "'cors_rule' allows all methods, all headers or several origins",
		"searchLine": common_lib.build_search_line(["module", name, "cors_rule"], []),
	}
}
