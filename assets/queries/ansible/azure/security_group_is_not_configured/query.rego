package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task.azure_rm_subnet

	object.get(subnet, "security_group", "undefined") == "undefined"
	object.get(subnet, "security_group_name", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_subnet.security_group is defined",
		"keyActualValue": "azure_rm_subnet.security_group is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task.azure_rm_subnet

	ansLib.checkValue(subnet.security_group)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}.security_group", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group is not empty or null",
		"keyActualValue": "azure_rm_subnet.security_group is empty or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	subnet := task.azure_rm_subnet

	ansLib.checkValue(subnet.security_group_name)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_subnet}}.security_group_name", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_subnet.security_group_name is not empty or null",
		"keyActualValue": "azure_rm_subnet.security_group_name is empty or null",
	}
}
