package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_service", "ecs_service"}
	ecs_service := task[modules[m]]
	ansLib.checkState(ecs_service)

	not common_lib.valid_key(ecs_service, "deployment_configuration")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.deployment_configuration should be defined", [modules[m]]),
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.deployment_configuration", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.deployment_configuration should have at least 1 task running", [modules[m]]),
		"keyActualValue": sprintf("%&s.deployment_configuration must have at least 1 task running", [modules[m]]),
	}
}

checkContent(deploymentConfiguration) {
    common_lib.valid_key(deploymentConfiguration, "maximum_percent")
}
checkContent(deploymentConfiguration) {
    common_lib.valid_key(deploymentConfiguration, "minimum_healthy_percent")
}
