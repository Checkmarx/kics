package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task.azure_rm_storageaccount.network_acls.default_action == "Allow"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.network_acls.default_action", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action is not set",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Allow'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task.azure_rm_storageaccount.network_acls.default_action == "Deny"

	ip_rules := task.azure_rm_storageaccount.network_acls.ip_rules

	some j
	ip_rules[j].value == "0.0.0.0/0"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.network_acls.ip_rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny' and azure_rm_storageaccount.network_acls.ip_rules does not contain value '0.0.0.0/0' ",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny' and azure_rm_storageaccount.network_acls.ip_rules contains value '0.0.0.0/0'",
	}
}
