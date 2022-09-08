package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::S3::Bucket"

	rule := resource.Properties.CorsConfiguration.CorsRules[c]
	common_lib.unsecured_cors_rule(rule.AllowedMethods, rule.AllowedHeaders, rule.AllowedOrigins)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.CorsConfiguration.CorsRules", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.CorsConfiguration.CorsRules[%d] should not allow all methods, all headers or several origins", [name, c]),
		"keyActualValue": sprintf("Resources.%s.Properties.CorsConfiguration.CorsRules[%d] allows all methods, all headers or several origins", [name, c]),
	}
}
