package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	rule := resource.Properties.CorsConfiguration.CorsRules[c]
	common_lib.unsecured_cors_rule(rule.AllowedMethods, rule.AllowedHeaders, rule.AllowedOrigins)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.CorsConfiguration.CorsRules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CorsConfiguration.CorsRules[%d] does not allows all methods, all headers or several origins", [name, c]),
		"keyActualValue": sprintf("Resources.%s.Properties.CorsConfiguration.CorsRules[%d] allows all methods, all headers or several origins", [name, c]),
	}
}
