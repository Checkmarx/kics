package Cx

CxPolicy [  result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.iam_managed_policy"]
  checkState(awsApiGateway)
  statement := awsApiGateway.policy.Statement[_]
  contains(statement.Resource, "*")
  contains(statement.Effect, "Allow")
  clusterName := task.name
  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Resource", [clusterName]),
                "issueType":        "MissingValue",
                "keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Resource not equal '*'",
                "keyActualValue":   "community.aws.iam_managed_policy.policy.Statement.Resource equal '*'"
              }
}

CxPolicy [result] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  awsApiGateway := task["community.aws.iam_managed_policy"]
  checkState(awsApiGateway.state)
  policy := json_unmarshal(awsApiGateway.policy)
  statement := policy.Statement[_]
  contains(statement.Resource, "*")
  contains(statement.Effect, "Allow")
  clusterName := task.name
  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [clusterName]),
                "issueType":        "IncorrectAttribute",
                "keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
                "keyActualValue":   "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains ':root'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

json_unmarshal(s) = result {
	s == null
	result := json.unmarshal("{}")
}

json_unmarshal(s) = result {
	s != null
	result := json.unmarshal(s)
}

checkState(awsApiGateway){
contains(awsApiGateway.state, "present")
}else{
object.get(awsApiGateway, "state", "undefined") == "undefined"
}
