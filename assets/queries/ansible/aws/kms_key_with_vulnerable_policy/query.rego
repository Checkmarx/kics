package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  aws_kms := task["community.aws.aws_kms"]
  policy_exists := object.get(aws_kms, "policy", "undefined") != "undefined"

  statement = aws_kms.policy.Statement[_]
  check_permission(statement) == true

    result := {
            "documentId": document.id,
            "searchKey": sprintf("name=%s.{{community.aws.aws_kms}}.policy", [task.name]),
            "issueType": "IncorrectValue",
            "keyExpectedValue": sprintf("name=%s.{{community.aws.aws_kms}}.policy is correct", [task.name]),
            "keyActualValue": sprintf("name=%s.{{community.aws.aws_kms}}.policy is incorrect, the policy statement is too exposed", [task.name]),
        }
}


getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}

check_permission(statement) = true {
  statement.Principal.AWS == "*"
  statement.Action[i] == "kms:*"
  statement.Resource == "*"
}
