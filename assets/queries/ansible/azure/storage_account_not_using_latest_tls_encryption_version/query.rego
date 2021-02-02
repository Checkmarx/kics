package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	modules = {"azure.azcollection.azure_rm_storageaccount","azure_rm_storageaccount"}
	storage := task[modules[index]]

	object.get(storage, "minimum_tls_version", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{%s}}.minimum_tls_version is defined", [task.name, modules[index]]),
		"keyActualValue": sprintf("name=%s.{{%s}}.minimum_tls_version is undefined", [task.name, modules[index]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	modules = {"azure.azcollection.azure_rm_storageaccount","azure_rm_storageaccount"}
	tls_version := task[modules[index]].minimum_tls_version
	not tls_version == "TLS1_2"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}.minimum_tls_version", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{%s}} is using the latest version of TLS encryption", [task.name, modules[index]]),
		"keyActualValue": sprintf("name=%s.{{%s}} is using version %s of TLS encryption", [task.name, modules[index], tls_version]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
