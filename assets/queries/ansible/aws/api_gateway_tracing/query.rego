package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.aws_api_gateway"]
  isFalse(awsApiGateway.tracing_enabled)
  clusterName := task.name

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.aws_api_gateway}}.tracing_enabled", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "community.aws.aws_api_gateway.tracing_enabled should be enabled",
                "keyActualValue":   "community.aws.aws_api_gateway.tracing_enabled is disabled"
              }
}

isFalse(answer) {
lower(answer) == "no"
} else {
lower(answer) == "false"
} else {
answer == false
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
