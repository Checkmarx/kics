package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	contDef := resource.Properties.ContainerDefinitions[_]
	object.get(contDef, "HealthCheck", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ContainerDefinitions", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' contains 'HealthCheck' property", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' doesn't contain 'HealthCheck' property", [name]),
	}
}
