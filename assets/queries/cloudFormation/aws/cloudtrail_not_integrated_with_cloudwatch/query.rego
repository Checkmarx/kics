package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	some name in document.Resources
	resource := document.Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	attributes := {"CloudWatchLogsLogGroupArn", "CloudWatchLogsRoleArn"}
	some a in attributes
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
