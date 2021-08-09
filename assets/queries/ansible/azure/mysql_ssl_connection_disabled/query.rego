package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_mysqlserver", "azure_rm_mysqlserver"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task[modules[m]]
	ansLib.checkState(storageAccount)

	not common_lib.valid_key(storageAccount, "enforce_ssl")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure_rm_mysqlserver does not have enforce_ssl (defaults to false)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task[modules[m]]
	ansLib.checkState(storageAccount)

	not ansLib.isAnsibleTrue(storageAccount.enforce_ssl)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enforce_ssl", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_mysqlserver should have enforce_ssl set to true",
		"keyActualValue": "azure_rm_mysqlserver does has enforce_ssl set to false",
	}
}
