package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules = {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	storage := task[modules[index]]

	object.get(storage, "minimum_tls_version", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{%s}}.minimum_tls_version is defined", [task.name, modules[index]]),
		"keyActualValue": sprintf("name=%s.{{%s}}.minimum_tls_version is undefined", [task.name, modules[index]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules = {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	tls_version := task[modules[index]].minimum_tls_version

	tls_version != "TLS1_2"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}.minimum_tls_version", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{%s}} is using the latest version of TLS encryption", [task.name, modules[index]]),
		"keyActualValue": sprintf("name=%s.{{%s}} is using version %s of TLS encryption", [task.name, modules[index], tls_version]),
	}
}
