package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task.azure_rm_aks, "addon", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon is set",
		"keyActualValue": "azure_rm_aks.addon is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task.azure_rm_aks.addon, "monitoring", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring is set",
		"keyActualValue": "azure_rm_aks.addon.monitoring is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	attributes := {"enabled", "log_analytics_workspace_resource_id"}

	object.get(task.azure_rm_aks.addon.monitoring, attributes[j], "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon.monitoring", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azure_rm_aks.addon.monitoring.%s is set", [attributes[j]]),
		"keyActualValue": sprintf("azure_rm_aks.addon.monitoring.%s is undefined", [attributes[j]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	not isYesOrTrue(task.azure_rm_aks.addon.monitoring.enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon.monitoring.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring.enabled is set to 'yes' or 'false'",
		"keyActualValue": "azure_rm_aks.addon.monitoring.enabled is not set to 'yes' or 'false'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isYesOrTrue(attribute) {
	options := {"yes", true}
	attribute == options[j]
}
