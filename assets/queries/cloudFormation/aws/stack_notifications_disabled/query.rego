package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFormation::Stack"

	not common_lib.valid_key(resource.Properties, "NotificationARNs")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NotificationARNs should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.NotificationARNs is undefined", [name]),
	}
}
