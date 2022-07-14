package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage := task[modules[m]]
	ansLib.checkState(storage)

	not common_lib.valid_key(storage, "minimum_tls_version")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_storageaccount.minimum_tls_version should be defined",
		"keyActualValue": "azure_rm_storageaccount.minimum_tls_version is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage := task[modules[m]]
	ansLib.checkState(storage)

	storage.minimum_tls_version != "TLS1_2"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.minimum_tls_version", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount should be using the latest version of TLS encryption",
		"keyActualValue": sprintf("azure_rm_storageaccount is using version %s of TLS encryption", [storage.minimum_tls_version]),
	}
}
