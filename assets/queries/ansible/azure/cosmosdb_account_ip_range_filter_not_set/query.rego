package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t].azure_rm_cosmosdbaccount

	not task.ip_range_filter

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_cosmosdb_account.ip_range_filter' is defined",
		"keyActualValue": "'azurerm_cosmosdb_account.ip_range_filter' is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
