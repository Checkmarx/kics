package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFormation::Stack"

	object.get(resource.Properties, "NotificationARNs", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NotificationARNs is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.NotificationARNs is undefined", [name]),
	}
}
