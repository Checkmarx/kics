package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::Stack"

	not common_lib.valid_key(resource.Properties, "NotificationARNs")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NotificationARNs is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.NotificationARNs is undefined", [name]),
	}
}
