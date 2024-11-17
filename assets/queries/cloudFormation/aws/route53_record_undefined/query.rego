package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Route53::HostedZone"

	not check_resources_type(document.Resources)

	result := {
		"documentId": document.id,
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
