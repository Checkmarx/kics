package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task["azure.azcollection.azure_rm_mysqlserver"]

	object.get(storageAccount, "enforce_ssl", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_mysqlserver}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure.azcollection.azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure.azcollection.azure_rm_mysqlserver does not have enforce_ssl (defaults to false)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task["azure.azcollection.azure_rm_mysqlserver"]

	not ansLib.isAnsibleTrue(storageAccount.enforce_ssl)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_mysqlserver}}.enforce_ssl", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "azure.azcollection.azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure.azcollection.azure_rm_mysqlserver does has enforce_ssl set to false",
	}
}
