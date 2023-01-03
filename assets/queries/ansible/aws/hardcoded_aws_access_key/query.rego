package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.ec2_instance", "ec2_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance := task[modules[m]]
	checkState(ec2_instance)

	re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", ec2_instance.user_data)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.user_data", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ec2_instance.user_data' shouldn't contain access key",
		"keyActualValue": "'ec2_instance.user_data' contains access key",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ec2_instance := task[modules[m]]
	checkState(ec2_instance)

	re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", ec2_instance.user_data)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.user_data", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ec2_instance.user_data' shouldn't contain access key",
		"keyActualValue": "'ec2_instance.user_data' contains access key",
	}
}

checkState(task) {
	state := object.get(task, "state", "undefined")
	state != "absent"
	state != "list"
}
