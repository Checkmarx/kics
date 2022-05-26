package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Subnet"
	resource.Properties.MapPublicIpOnLaunch == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MapPublicIpOnLaunch", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' should be false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' is true", [name]),
	}
}
