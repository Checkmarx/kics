package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_sqs_queue[name]
  policy := json_unmarshal(resource.policy)
  statement = policy.Statement[_]
  check_role(statement, "*") == true 

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("resource.aws_sqs_queue[%s].policy.Principal", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("resource.aws_sqs_queue[%s].policy.Principal doesn't get the queue publicly accessible", [name]),
                "keyActualValue": 	sprintf("resource.aws_sqs_queue[%s].policy.Principal does get the queue publicly accessible", [name]),
              }
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