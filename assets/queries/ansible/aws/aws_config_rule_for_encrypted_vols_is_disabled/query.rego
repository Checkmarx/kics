package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  configRule := task["community.aws.aws_config_rule"]
  configRuleName := task.name

  not upper(configRule.source.identifier) == "ENCRYPTED_VOLUMES"

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.aws_config_rule}}.source.identifier", [configRuleName]),
                "issueType":        "WrongValue",
                "keyExpectedValue": "community.aws.aws_config_rule.source.identifier should not have value ENCRYPTED_VOLUMES",
                "keyActualValue":   "community.aws.aws_config_rule.source.identifier is equal to ENCRYPTED_VOLUMES"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
