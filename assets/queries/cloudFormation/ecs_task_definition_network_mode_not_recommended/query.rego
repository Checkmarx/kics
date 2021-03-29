package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	properties := resource.Properties
	object.get(properties, "NetworkMode", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.NetworkMode' is set and is 'awsvpc'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.NetworkMode' is undefined and defaults to 'bridge'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	properties := resource.Properties
	object.get(properties, "NetworkMode", "undefined") != "undefined"

    properties.NetworkMode != "awsvpc"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.NetworkMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.NetworkMode' is 'awsvpc'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.NetworkMode' is '%s'", [name,properties.NetworkMode]),
	}
}
