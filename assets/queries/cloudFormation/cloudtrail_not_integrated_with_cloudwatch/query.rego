package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	attributes := {"CloudWatchLogsLogGroupArn", "CloudWatchLogsRoleArn"}
	attr := attributes[a]
	
	not common_lib.valid_key(resource.Properties, attr)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' is declared", [name, attr]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is not declared", [name, attr]),
	}
}
