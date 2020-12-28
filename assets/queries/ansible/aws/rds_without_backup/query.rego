package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["community.aws.rds_instance"]
  instanceName := task.name

  object.get(instance, "backup_retention_period", "undefined") == "undefined"

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.rds_instance}}", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
                "keyActualValue":   "community.aws.rds_instance has the property 'backup_retention_period' unassigned"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["community.aws.rds_instance"]
  instanceName := task.name

  instance.backup_retention_period == 0

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.rds_instance}}.backup_retention_period", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
                "keyActualValue":   "community.aws.rds_instance has the property 'backup_retention_period' assigned to 0"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

