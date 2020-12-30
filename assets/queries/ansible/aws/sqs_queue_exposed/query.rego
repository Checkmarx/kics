package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policy := json_unmarshal(task["community.aws.sqs_queue"].policy)
  statement = policy.Statement[_]
  check_role(statement, "*") == true 

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal doesn't get the queue publicly accessible", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal does get the queue publicly accessible", [task.name]),
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
    s.Principal == p
}