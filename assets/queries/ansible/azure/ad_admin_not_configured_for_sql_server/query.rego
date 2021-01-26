package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t].azure_rm_sqlserver

	object.get(task, "ad_user", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_sqlserver}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ad_user' is defined",
		"keyActualValue": "'ad_user' is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
