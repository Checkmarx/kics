package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	resourceDefinition = resource.container_definitions
	resourceJson = json_unmarshal(resourceDefinition)
	env = resourceJson.containerDefinitions[_].environment[_]
	contains(upper(env.name), upper("password"))

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [env.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'container_definitions.environment.name' doesn't have password value",
		"keyActualValue": "'container_definitions.environment.name' has password value",
	}
}

json_unmarshal(s) = result {
	s == null
	result := json.unmarshal("{}")
}

json_unmarshal(s) = result {
	s != null
	result := json.unmarshal(s)
}
