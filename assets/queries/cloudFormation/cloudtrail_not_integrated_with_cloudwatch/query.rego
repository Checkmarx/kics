package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	attr := {"CloudWatchLogsLogGroupArn", "CloudWatchLogsRoleArn"}

	object.get(resource.Properties, attr[a], "not found") == "not found"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' is declared", [name, attr[a]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is not declared", [name, attr[a]]),
	}
}
