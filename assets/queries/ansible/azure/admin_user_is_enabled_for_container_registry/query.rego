package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	containerReg := task["azure.azcollection.azure_rm_containerregistry"]

	ansLib.isAnsibleTrue(containerReg.admin_user_enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_containerregistry}}.admin_user_enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure.azcollection.azure_rm_containerregistry.admin_user_enabled should be false or undefined (defaults to false)",
		"keyActualValue": "azure.azcollection.azure_rm_containerregistry.admin_user_enabled is true",
	}
}
