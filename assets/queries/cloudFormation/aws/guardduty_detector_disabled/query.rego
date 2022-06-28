package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GuardDuty::Detector"
	properties := resource.Properties
	properties.Enable == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Enable is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Enable is set to false", [name]),
	}
}
