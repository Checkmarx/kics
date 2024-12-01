package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::SDB::Domain"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s should not be defined", [name]),
		"keyActualValue": sprintf("Resources.%s is defined", [name]),
	}
}
