package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	isAnsibleFalse(task.azure_rm_keyvault.enable_soft_delete)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_keyvault}}.enable_soft_delete", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is true",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	not task.azure_rm_keyvault.enable_soft_delete

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_keyvault}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_keyvault.enable_soft_delete is defined",
		"keyActualValue": "azure_rm_keyvault.enable_soft_delete is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
