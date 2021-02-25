package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task.azure_rm_rediscache

	ansLib.isAnsibleTrue(instance.enable_non_ssl_port)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port is false or undefined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{azure_rm_rediscache}}.enable_non_ssl_port is true", [task.name]),
	}
}
