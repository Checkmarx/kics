package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	doc := document.Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	resource.Properties.Monitoring == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Monitoring' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Monitoring' is set to 'false'", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	doc := document.Resources
	resource := doc[name]
	resource.Type == "AWS::EC2::Instance"

	not common_lib.valid_key(resource.Properties, "Monitoring")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Monitoring", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Monitoring' should be set and to 'true'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Monitoring' is not set", [name]),
	}
}
