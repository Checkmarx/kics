package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	modules := {"azure.azcollection.azure_rm_virtualmachine", "azure_rm_virtualmachine"}
	task := ansLib.tasks[id][t]
	virtualmachine := task[modules[m]]
	ansLib.checkState(virtualmachine)

	not common_lib.valid_key(virtualmachine, "network_interface_names")
	not common_lib.valid_key(virtualmachine, "network_interfaces")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_virtualmachine.network_interface_names should be defined",
		"keyActualValue": "azure_rm_virtualmachine.network_interface_names is undefined",
	}
}
