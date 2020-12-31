package Cx

CxPolicy [ result ] { 
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policyBody := task["community.aws.iam_password_policy"]
  object.get(policyBody,"require_lowercase","undefined") == "undefined"
  policyName := task.name

              result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [policyName]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' set and true", [policyName]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.iam_password_policy}} have 'require_lowercase' undefined", [policyName]),
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policyBody := task["community.aws.iam_password_policy"]
  checkFalse(policyBody.require_lowercase)
  policyName := task.name

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase", [policyName]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is true", [policyName]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.iam_password_policy}}.require_lowercase is false", [policyName]),
              }
}

checkFalse(uppercase){
lower(uppercase) == "no"
} else {
lower(uppercase) == "false"
} else {
uppercase == false
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
