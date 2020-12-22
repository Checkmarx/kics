package Cx

CxPolicy [  result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.lambda"]
  contains(awsApiGateway.state, "present")
  role := awsApiGateway.role
  endswith(role, "/*")
  clusterName := task.name
  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.lambda}}.role", [clusterName]),
                "issueType":        "MissingValue",
                "keyExpectedValue": "community.aws.lambda.role shoud not contain /* Instead, it should be defined for the pretended access to any other AWS resource",
                "keyActualValue":   "community.aws.lambda.role contains /*"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}