package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	api_gateway := task[modules[m]]
	ansLib.checkState(api_gateway)

	not common_lib.valid_key(api_gateway, "validate_certs")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_api_gateway.validate_certs should be set",
		"keyActualValue": "aws_api_gateway.validate_certs is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	api_gateway := task[modules[m]]
	ansLib.checkState(api_gateway)

	not ansLib.isAnsibleTrue(api_gateway.validate_certs)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.validate_certs", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway.validate_certs should be set to yes",
		"keyActualValue": "aws_api_gateway.validate_certs is not set to yes",
	}
}
