package Cx


CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  sqsPolicy := task["community.aws.sqs_queue"]
  sqsPolicyName := task.name
  contains(sqsPolicy.policy.Statement[_].Action,"*")


	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement", [sqsPolicyName]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement should not contain Action equal to '*'", [sqsPolicyName]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement contains Action equal to '*'", [sqsPolicyName]),
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
