package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t].azure_rm_virtualmachine

	object.get(task, "network_interface_names", "undefined") == "undefined"
	object.get(task, "network_interfaces", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_virtualmachine}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_interface_names' is defined",
		"keyActualValue": "'network_interface_names' is undefined",
	}
}
