package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ec2_instance", "ec2_instance", "amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	checkState(ec2)

	not common_lib.valid_key(ec2, "vpc_subnet_id")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.vpc_subnet_id should be set", [modules[m]]),
		"keyActualValue": sprintf("%s.vpc_subnet_id is undefined", [modules[m]]),
	}
}

checkState(task) {
	state := object.get(task, "state", "undefined")
	state != "absent"
	state != "list"
}
