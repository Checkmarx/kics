package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	contDef := resource.Properties.ContainerDefinitions[_]
	not common_lib.valid_key(contDef, "HealthCheck")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ContainerDefinitions", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' contains 'HealthCheck' property", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' doesn't contain 'HealthCheck' property", [name]),
	}
}
