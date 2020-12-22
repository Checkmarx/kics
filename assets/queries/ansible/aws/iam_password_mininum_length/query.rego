package Cx

CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  firstPolicy = tasks[_]
  policyBody = firstPolicy["community.aws.iam_password_policy"]
  policyName = firstPolicy.name

   not policyBody.min_pw_length


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.{{community.aws.iam_password_policy}}", [policyName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'min_pw_length' is set and no less than 8",
                "keyActualValue": 	"'min_pw_length' is undefined"
              }
}

CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  firstPolicy = tasks[_]
  policyBody = firstPolicy["community.aws.iam_password_policy"]
  policyName = firstPolicy.name


  to_number(policyBody.min_pw_length) < 8

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.{{community.aws.iam_password_policy}}.{{min_pw_length}}", [policyName]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'min_pw_length' is set and no less than 8",
                "keyActualValue": 	"'min_pw_length' is less than 8"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
