package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	postgresql_configuration := task.azure_rm_postgresqlconfiguration

	is_string(postgresql_configuration.name)
	lower(postgresql_configuration.name) == "log_retention"

	is_string(postgresql_configuration.value)
	lower(postgresql_configuration.value) != "on"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_postgresqlconfiguration}}.value", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'value' is equal to 'on'",
		"keyActualValue": "'value' is not equal to 'on'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
