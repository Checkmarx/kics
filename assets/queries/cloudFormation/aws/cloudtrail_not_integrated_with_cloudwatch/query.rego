package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	attributes := {"CloudWatchLogsLogGroupArn", "CloudWatchLogsRoleArn"}
	attr := attributes[a]

	not common_lib.valid_key(resource.Properties, attr)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' should be declared", [name, attr]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is not declared", [name, attr]),
	}
}
