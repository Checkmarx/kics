package Cx


CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  sqsPolicy := task["community.aws.sqs_queue"]
  sqsPolicyName := task.name
  contains(sqsPolicy.policy.Statement[_].Principal, "*")
  contains(sqsPolicy.policy.Statement[_].Effect , "Allow")
  contains(sqsPolicy.policy.Statement[_].Action ,"*")

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal", [sqsPolicyName]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal should not be equal to '*'", [sqsPolicyName]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal is equal to '*'", [sqsPolicyName]),
              }
}
CxPolicy [ result] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  sqsPolicy := task["community.aws.sqs_queue"]
  sqsPolicyName := task.name
  contains(sqsPolicy.policy.Statement[_].Effect , "Allow")
  contains(sqsPolicy.policy.Statement[_].Action ,"*")
  checkPrincipal(sqsPolicy.policy.Statement[_].Principal[j])


	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS", [sqsPolicyName]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS should not be equal to '*'", [sqsPolicyName]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal.AWS is equal to '*'", [sqsPolicyName]),
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

checkPrincipal(principal){
  contains(principal.AWS,"*")
}else{
  contains(principal.AWS[k],"*")
}