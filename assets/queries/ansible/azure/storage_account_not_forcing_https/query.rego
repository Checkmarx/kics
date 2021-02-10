package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	modules = {"azure.azcollection.azure_rm_storageaccount","azure_rm_storageaccount"}
	storageAccount := task[modules[index]]
	storageAccountName := task.name

	object.get(storageAccount, "https_only", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [storageAccountName, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.https_only is defined",[modules[index]]),
		"keyActualValue": sprintf("%s.https_only is undefined (defaults to false)",[modules[index]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	modules = {"azure.azcollection.azure_rm_storageaccount","azure_rm_storageaccount"}
	storageAccount := task[modules[index]]
	storageAccountName := task.name
	not isAnsibleTrue(storageAccount.https_only)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.https_only", [storageAccountName, modules[index]]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("%s should have https_only set to true",[modules[index]]),
		"keyActualValue": sprintf("%s has https_only set to false",[modules[index]]),
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
