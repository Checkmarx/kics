package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  configRules := [t | tasks[_]["community.aws.aws_config_rule"]; t := tasks[x]]

  not checkSource(configRules, "ENCRYPTED_VOLUMES")

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.aws_config_rule}}.source.identifier", [configRules[0].name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "There should be a aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'",
                "keyActualValue":   "There is no aws_config_rule with source.identifier equal to 'ENCRYPTED_VOLUMES'"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

checkSource(configRules,expected_source) = true {
	source := configRules[_]["community.aws.aws_config_rule"].source
  upper(source.identifier) == expected_source
}