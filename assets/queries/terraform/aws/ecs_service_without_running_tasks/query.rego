package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_service[name]

	not checkContent(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_service[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_service[%s]' has at least 1 task running'", [name]),
		"keyActualValue": sprintf("'aws_ecs_service[%s]' must have at least 1 task running", [name]),
	}
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "deployment_maximum_percent", "undefined") != "undefined"
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "deployment_minimum_healthy_percent", "undefined") != "undefined"
}
