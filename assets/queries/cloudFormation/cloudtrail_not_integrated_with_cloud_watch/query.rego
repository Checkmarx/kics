package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	object.get(resource.Properties, "CloudWatchLogsRoleArn", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.CloudWatchLogsRoleArn' should exist", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.CloudWatchLogsRoleArn' doesn't exist", [name]),
	}
}
