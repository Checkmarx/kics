package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.aws_api_gateway"]
  awsApiGateway.tracing_enabled == "disable"
  clusterName := task.name

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.aws_api_gateway}}.tracing_enabled", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "community.aws.aws_api_gateway.tracing_enabled should be enable",
                "keyActualValue":   "community.aws.aws_api_gateway.tracing_enabled is disable"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}