package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.ec2_asg", "ec2_asg"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	resource := task[modules[m]]
	ansLib.checkState(resource)

	not common_lib.valid_key(resource, "load_balancers")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.load_balancers should be set and not empty", [modules[m]]),
		"keyActualValue": sprintf("%s.load_balancers is undefined", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	resource := task[modules[m]]
	ansLib.checkState(resource)

	is_array(resource.load_balancers) == true
	count(resource.load_balancers) == 0

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.load_balancers", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.load_balancers should not be empty", [modules[m]]),
		"keyActualValue": sprintf("%s.load_balancers is empty", [modules[m]]),
	}
}
