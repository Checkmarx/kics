package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policy := json_unmarshal(task["amazon.aws.s3_bucket"].policy)
  statement = policy.Statement[_]
  check_role(statement.Principal, "*") == true
  check_role(statement.Effect, "Allow") == true
  check_role(statement.Action, "*") == true

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement doesn't make the bucket accessible to all AWS Accounts", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement does make the bucket accessible to all AWS Accounts", [task.name]),
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

check_role(s, p) = true {
    s == p
}
