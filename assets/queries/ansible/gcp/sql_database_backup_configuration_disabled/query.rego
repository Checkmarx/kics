package Cx

CxPolicy [ result ] {
  document := input.document[i]
  task := getTasks(document)[t]

  path := getPathDefinitions(task["google.cloud.gcp_sql_instance"])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}%s", [task.name, path.defined]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'%s' is defined", [path.undefined]),
                "keyActualValue": 	sprintf("'%s' is undefined", [path.undefined])
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  task := getTasks(document)[t]

  not isAnsibleTrue(task["google.cloud.gcp_sql_instance"].settings.backup_configuration.enabled)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.backup_configuration.enabled", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'settings.backup_configuration.require_ssl' is true",
                "keyActualValue": 	"'settings.backup_configuration.require_ssl' is false"
              }
}

getPathDefinitions(instance) = result {
	object.get(instance, "settings", "undefined") == "undefined"
    result = { "defined": "", "undefined": "settings" }
}
getPathDefinitions(instance) = result {
	object.get(instance.settings, "backup_configuration", "undefined") == "undefined"
    result = { "defined": ".settings", "undefined": "settings.backup_configuration" }
}
getPathDefinitions(instance) = result {
	object.get(instance.settings.backup_configuration, "enabled", "undefined") == "undefined"
    result = { "defined": ".settings.backup_configuration", "undefined": "settings.backup_configuration.enabled" }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

isAnsibleTrue(answer) {
 	lower(answer) == "yes"
} else {
  lower(answer) == "true"
} else {
	answer == true
}