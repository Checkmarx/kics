package Cx

CxPolicy [  result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.iam_managed_policy"]
  contains(awsApiGateway.state, "present")
  resource := awsApiGateway.policy.Statement[_].Resource
  contains(resource, "*")
  clusterName := task.name
  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Resource", [clusterName]),
                "issueType":        "MissingValue",
                "keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Resource not equal '*'",
                "keyActualValue":   "community.aws.iam_managed_policy.policy.Statement.Resource equal '*'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}