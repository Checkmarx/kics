package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_service", "ecs_service"}
	ecs_service := task[modules[m]]
	ansLib.checkState(ecs_service)

	object.get(ecs_service, "deployment_configuration", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.deployment_configuration is defined", [modules[m]]),
		"keyActualValue": sprintf("%&s.deployment_configuration is undefined", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_service", "ecs_service"}
	ecs_service := task[modules[m]]
	ansLib.checkState(ecs_service)

	not checkContent(ecs_service.deployment_configuration)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.deployment_configuration", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.deployment_configuration has at least 1 task running", [modules[m]]),
		"keyActualValue": sprintf("%&s.deployment_configuration must have at least 1 task running", [modules[m]]),
	}
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "maximum_percent", "undefined") != "undefined"
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "minimum_healthy_percent", "undefined") != "undefined"
}
