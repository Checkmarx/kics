package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  contains(instance.database_version, "SQLSERVER")
  settings := instance.settings
  database_flags := settings.database_flags

  check_database_flags_content(database_flags)

  result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "cloud_gcp_sql_instance.settings.database_flags are correct",
                "keyActualValue": "cloud_gcp_sql_instance.settings.database_flags.name is 'contained database authentication' and cloud_gcp_sql_instance.settings.database_flags.value is 'on'"
              }
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}

check_database_flags_content(database_flags) {
	database_flags[x].name == "contained database authentication"
    isAnsibleValue(database_flags[x].value)
}

check_database_flags_content(database_flags) {
	database_flags.name == "contained database authentication"
    isAnsibleValue(database_flags.value)
}

isAnsibleValue(answer) {
 	lower(answer) == "on"
} else {
	answer == 1
}
