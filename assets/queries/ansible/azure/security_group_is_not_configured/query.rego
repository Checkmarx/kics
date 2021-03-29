package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

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
	fields := ["security_group", "security_group_name"]

	commonLib.emptyOrNull(subnet[fields[f]])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azure_rm_subnet.%s is not empty nor null", [fields[f]]),
		"keyActualValue": sprintf("azure_rm_subnet.%s is empty or null", [fields[f]]),
	}
}
