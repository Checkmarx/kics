package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	task.azure_rm_cosmosdbaccount
	not task.azure_rm_cosmosdbaccount.tags

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags is undefined", [task.name]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
