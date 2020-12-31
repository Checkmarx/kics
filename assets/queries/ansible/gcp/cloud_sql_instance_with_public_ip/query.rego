package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  ip_configuration := settings.ip_configuration

  isAnsibleTrue(ip_configuration.ipv4_enabled)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.ip_configuration.ipv4_enabled", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "cloud_gcp_sql_instance.settings.ip_configuration.ipv4_enabled is disabled",
                "keyActualValue": 	"cloud_gcp_sql_instance.settings.ip_configuration.ipv4_enabled is enabled"
              }
}

isAnsibleTrue(answer) {
 	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}
