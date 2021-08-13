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
	}
}
