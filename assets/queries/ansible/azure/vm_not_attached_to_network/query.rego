package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	modules := {"azure.azcollection.azure_rm_virtualmachine", "azure_rm_virtualmachine"}
	task := ansLib.tasks[id][t]
	virtualmachine := task[modules[m]]
	ansLib.checkState(virtualmachine)

	object.get(virtualmachine, "network_interface_names", "undefined") == "undefined"
	object.get(virtualmachine, "network_interfaces", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_virtualmachine.network_interface_names is defined",
		"keyActualValue": "azure_rm_virtualmachine.network_interface_names is undefined",
	}
}
