package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	storageAccount := task.azure_rm_storageaccount
	storageAccountName := task.name

	default_action := storageAccount.network_acls.default_action

	is_string(default_action)
	lower(default_action) == "allow"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_storageaccount}}.network_acls.default_action", [storageAccountName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny'",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Allow'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
