package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  pgConfig := task["azure.azcollection.azure_rm_postgresqlconfiguration"]
  pgConfigName := task.name
  
  is_string(pgConfig.name)
  name := lower(pgConfig.name)

  is_string(pgConfig.value)
  value := upper(pgConfig.value)

  name == "log_disconnections"
  value != "ON"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure.azcollection.azure_rm_postgresqlconfiguration}}.value", [pgConfigName]),
                "issueType":        "WrongValue",
                "keyExpectedValue": "azure.azcollection.azure_rm_postgresqlconfiguration.value should be 'ON' when name is 'log_disconnections'",
                "keyActualValue":   "azure.azcollection.azure_rm_postgresqlconfiguration.value if 'OFF'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
