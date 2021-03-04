package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_instance", "amazon.aws.ec2"}

	object.get(task[modules[index]], "vpc_subnet_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.vpc_subnet_id is set", [modules[index]]),
		"keyActualValue": sprintf("%s.vpc_subnet_id is undefined", [modules[index]]),
	}
}
