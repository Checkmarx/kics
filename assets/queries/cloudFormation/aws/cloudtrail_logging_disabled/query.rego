package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	cf_lib.isCloudFormationFalse(resource.Properties.IsLogging)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IsLogging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsLogging' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsLogging' is false", [name]),
	}
}
