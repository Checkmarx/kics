package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Route53::HostedZone"

	not check_resources_type(document[i].Resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s has RecordSet", [name]),
		"keyActualValue": sprintf("Resources.%s doesn't have RecordSet", [name]),
	}
}

check_resources_type(resource) {
	resource[_].Type == "AWS::Route53::RecordSet"
}
