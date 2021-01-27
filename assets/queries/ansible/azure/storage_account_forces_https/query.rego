package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	storageAccount := task["azure.azcollection.azure_rm_storageaccount"]
	storageAccountName := task.name

	object.get(storageAccount, "https_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_storageaccount}}", [storageAccountName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure.azcollection.azure_rm_storageaccount should have https_only set to true",
		"keyActualValue": "azure.azcollection.azure_rm_storageaccount does not have https_only (defaults to false)",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	storageAccount := task["azure.azcollection.azure_rm_storageaccount"]
	storageAccountName := task.name
	not isAnsibleTrue(storageAccount.https_only)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_storageaccount}}.https_only", [storageAccountName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "azure.azcollection.azure_rm_storageaccount should have https_only set to true",
		"keyActualValue": "azure.azcollection.azure_rm_storageaccount does has https_only set to false",
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
