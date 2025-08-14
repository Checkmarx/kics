package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[key]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.Encrypted)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("EFS resource '%s' should have encryption enabled", [key]),
		"keyActualValue": sprintf("EFS resource '%s' has encryption set to false", [key]),
	}
}
