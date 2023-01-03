package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	properties := resource.Properties
	not common_lib.valid_key(properties, "NetworkMode")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.NetworkMode' should be set and should be 'awsvpc'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.NetworkMode' is undefined and defaults to 'bridge'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	properties := resource.Properties

    properties.NetworkMode != "awsvpc"
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.NetworkMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.NetworkMode' should be 'awsvpc'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.NetworkMode' is '%s'", [name,properties.NetworkMode]),
	}
}
