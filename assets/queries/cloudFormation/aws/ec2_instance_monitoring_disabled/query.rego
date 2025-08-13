package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	cf_lib.isCloudFormationFalse(resource.Properties.Monitoring)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Monitoring' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Monitoring' is set to 'false'", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i].Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	not common_lib.valid_key(resource.Properties, "Monitoring")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Monitoring", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Monitoring' should be set and to 'true'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Monitoring' is not set", [name]),
	}
}
