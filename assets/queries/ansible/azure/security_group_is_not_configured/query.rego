package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_subnet", "azure_rm_subnet"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task[modules[m]]
	ansLib.checkState(subnet)

	not common_lib.valid_key(subnet, "security_group")
	not common_lib.valid_key(subnet, "security_group_name")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_subnet.security_group should be defined and not null",
		"keyActualValue": "azure_rm_subnet.security_group is undefined or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task[modules[m]]
	ansLib.checkState(subnet)
	fields := ["security_group", "security_group_name"]

	common_lib.valid_key(subnet, fields[f])
	subnet[fields[f]] == ""

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azure_rm_subnet.%s should not be empty", [fields[f]]),
		"keyActualValue": sprintf("azure_rm_subnet.%s is empty", [fields[f]]),
	}
}
