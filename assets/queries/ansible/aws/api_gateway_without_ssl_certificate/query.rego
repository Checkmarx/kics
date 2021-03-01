package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

	object.get(task[modules[index]], "validate_certs", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.validate_certs is set", [modules[index]]),
		"keyActualValue": sprintf("%s.validate_certs is undefined", [modules[index]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

	not ansLib.isAnsibleTrue(task[modules[index]].validate_certs)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}.validate_certs", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.validate_certs is set to yes", [modules[index]]),
		"keyActualValue": sprintf("%s.validate_certs is not set to yes", [modules[index]]),
	}
}
