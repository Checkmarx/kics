package Cx

CxPolicy [  result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cloudwatchlogs := task["community.aws.aws_config_aggregator"]

  not isAnsibleTrue(cloudwatchlogs.account_sources.all_aws_regions)

  result := {
                "documentId":       document.id,
                "searchKey":        sprintf("name=%s.{{community.aws.aws_config_aggregator}}.account_sources.all_aws_regions", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_config_aggregator.account_sources' should have all_aws_regions set to true",
                "keyActualValue": 	"'aws_config_aggregator.account_sources' has all_aws_regions set to false"
              }
}

CxPolicy [  result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cloudwatchlogs := task["community.aws.aws_config_aggregator"]

  not isAnsibleTrue(cloudwatchlogs.organization_source.all_aws_regions)


  result := {
                "documentId":       document.id,
                "searchKey":        sprintf("name=%s.{{community.aws.aws_config_aggregator}}.organization_source.all_aws_regions", [task.name]),
				        "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_config_aggregator.organization_source' should have all_aws_regions set to true",
                "keyActualValue": 	"'aws_config_aggregator.organization_source' has all_aws_regions set to false"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isAnsibleTrue(answer) {
 	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
