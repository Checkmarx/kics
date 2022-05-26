package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	contDef := resource.Properties.ContainerDefinitions[_]
	env := contDef.Environment[_]
    contains(env.Name,"password")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ContainerDefinitions.Environment.Name=password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Environment' doensn't a plaintext password", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Environment'contains a plaintext password", [name]),
	}
}
