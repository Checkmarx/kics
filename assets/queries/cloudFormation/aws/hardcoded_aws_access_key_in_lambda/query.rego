package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties

	envVars := properties.Environment.Variables
	regexAccessKey := ["[A-Za-z0-9/+=]{40}", "[A-Z0-9]{20}"]
	some var
	re_match(regexAccessKey[_], envVars[var])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Environment.Variables", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Environment.Variables shouldn't contain access key", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Environment.Variables contains access key", [key]),
	}
}
