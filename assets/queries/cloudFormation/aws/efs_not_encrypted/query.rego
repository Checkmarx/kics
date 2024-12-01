package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document

	resource = document.Resources[key]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	properties.Encrypted == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("EFS resource '%s' should have encryption enabled", [key]),
		"keyActualValue": sprintf("EFS resource '%s' has encryption set to false", [key]),
	}
}
