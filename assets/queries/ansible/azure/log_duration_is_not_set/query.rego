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

  name == "log_duration"
  value != "ON"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure.azcollection.azure_rm_postgresqlconfiguration}}.value", [pgConfigName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": sprintf("name={{%s}}.{{azure.azcollection.azure_rm_postgresqlconfiguration}}.value should be 'ON' for 'log_duration'", [pgConfigName]),
                "keyActualValue":   sprintf("name={{%s}}.{{azure.azcollection.azure_rm_postgresqlconfiguration}}.value is 'OFF' for 'log_duration'", [pgConfigName])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
