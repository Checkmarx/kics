package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageaccount := task[modules[m]]
	ansLib.checkState(storageaccount)

	lower(storageaccount.network_acls.default_action) == "allow"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_acls.default_action", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action should not be set",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Allow'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageaccount := task[modules[m]]
	ansLib.checkState(storageaccount)

	lower(storageaccount.network_acls.default_action) == "deny"

	ip_rules := storageaccount.network_acls.ip_rules

	some j
	ip_rules[j].value == "0.0.0.0/0"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_acls.ip_rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action should be set to 'Deny' and azure_rm_storageaccount.network_acls.ip_rules should not contain value '0.0.0.0/0' ",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny' and azure_rm_storageaccount.network_acls.ip_rules contains value '0.0.0.0/0'",
	}
}
