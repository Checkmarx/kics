package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_aks, "enable_rbac", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.enable_rbac is defined",
		"keyActualValue": "azure_rm_aks.enable_rbac is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	not ansLib.isAnsibleTrue(task.azure_rm_aks.enable_rbac)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.enable_rbac", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.enable_rbac is set to 'yes' or 'true'",
		"keyActualValue": "azure_rm_aks.enable_rbac is not set to 'yes' or 'true'",
	}
}
