package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  database_flags := settings.database_flags

  check_database_flags_content(database_flags)

  result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags sets the log_temp_files to 1", [task.name]),
                "keyActualValue":   sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags sets the log_temp_files to 0", [task.name])
              }
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}

check_database_flags_content(database_flags) {
	database_flags[x].name == "log_temp_files"
	database_flags[x].value != 0
}

check_database_flags_content(database_flags) {
	database_flags.name == "log_temp_files"
	database_flags.value != 0
}
