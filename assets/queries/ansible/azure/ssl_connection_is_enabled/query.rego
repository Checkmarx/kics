package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	storageAccount := task["azure.azcollection.azure_rm_mysqlserver"]
	storageAccountName := task.name

	object.get(storageAccount, "enforce_ssl", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_mysqlserver}}", [storageAccountName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure.azcollection.azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure.azcollection.azure_rm_mysqlserver does not have enforce_ssl (defaults to false)",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	storageAccount := task["azure.azcollection.azure_rm_mysqlserver"]
	storageAccountName := task.name
	not isAnsibleTrue(storageAccount.enforce_ssl)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_mysqlserver}}.enforce_ssl", [storageAccountName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "azure.azcollection.azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure.azcollection.azure_rm_mysqlserver does has enforce_ssl set to false",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
