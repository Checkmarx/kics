package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  ip_configuration := settings.ip_configuration

  isAnsibleFalse(ip_configuration.require_ssl)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.require_ssl", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is true",
                "keyActualValue": 	"cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is false"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  ip_configuration := settings.ip_configuration

  object.get(ip_configuration, "require_ssl", "undefined") == "undefined"

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration", [task.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is defined",
                "keyActualValue": 	"cloud_gcp_sql_instance.settings.ip_configuration.require_ssl is undefined"
              }
}

isAnsibleFalse(answer) {
 	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}
