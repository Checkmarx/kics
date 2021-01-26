package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	task.azure_rm_storageaccount.network_acls.default_action == "Deny"
	not containsAzureService(task.azure_rm_storageaccount.network_acls.bypass)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.network_acls.bypass", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.bypass is not set or contains 'AzureServices'",
		"keyActualValue": "azure_rm_storageaccount.network_acls.bypass does not contain 'AzureServices' ",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

containsAzureService(bypass) {
	bypass == "\"\""
}

containsAzureService(bypass) {
	values := split(bypass, ",")
	some j
	values[j] == "AzureServices"
}
