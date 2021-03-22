package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_subnet", "azure_rm_subnet"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task[modules[m]]
	ansLib.checkState(subnet)

	object.get(subnet, "security_group", "undefined") == "undefined"
	object.get(subnet, "security_group_name", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_subnet.security_group is defined",
		"keyActualValue": "azure_rm_subnet.security_group is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task[modules[m]]
	ansLib.checkState(subnet)

	ansLib.checkValue(subnet.security_group)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.security_group", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group is not empty nor null",
		"keyActualValue": "azure_rm_subnet.security_group is empty or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task[modules[m]]
	ansLib.checkState(subnet)

	ansLib.checkValue(subnet.security_group_name)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.security_group_name", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group_name is not empty nor null",
		"keyActualValue": "azure_rm_subnet.security_group_name is empty or null",
	}
}
