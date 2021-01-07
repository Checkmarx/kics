package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_sql_instance"]
  settings := instance.settings
  database_flags := settings.database_flags

  not check_database_flags_content(database_flags)

  result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags sets the log_min_messages to a valid value", [task.name]),
                "keyActualValue":   sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags doesn't sets the log_min_messages to a valid value", [task.name])
              }
}

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}

check_database_flags_content(database_flags) {
	database_flags[x].name == "log_min_messages"
    cmd := ["fatal","panic","log","error","warning","notice","info","debug1","debug2","debug3","debug4","debug5"]
    some k
	contains(database_flags[x].value, cmd[k])
}

check_database_flags_content(database_flags) {
	database_flags.name == "log_min_messages"
	cmd := ["fatal","panic","log","error","warning","notice","info","debug1","debug2","debug3","debug4","debug5"]
    some k
	contains(database_flags.value, cmd[k])
}
