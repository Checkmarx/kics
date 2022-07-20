package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type = "AWS::EC2::VPC"

	not CheckFlowLogExistance(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s has a FlowLogs resource associated", [name]),
		"keyActualValue": sprintf("Resources.%s doesn't have a FlowLogs resource associated", [name]),
	}
}

CheckFlowLogExistance(service) = result {
	result := [x |
		documents := input.document[index].Resources[a]
		documents.Type = "AWS::EC2::FlowLog"
		n := documents[_].ResourceId
		n == service
		x := true
	]

	count(result) > 0
}
