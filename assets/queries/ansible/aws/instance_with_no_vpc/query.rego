package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_instance", "ec2_instance", "amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ansLib.checkState(ec2)

	object.get(ec2, "vpc_subnet_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.vpc_subnet_id is set", [modules[m]]),
		"keyActualValue": sprintf("%s.vpc_subnet_id is undefined", [modules[m]]),
	}
}
