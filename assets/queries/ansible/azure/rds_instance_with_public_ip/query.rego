package Cx

CxPolicy [ result ] {
	document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  rdsRule := task["community.aws.rds_instance"]
  rdsRuleName := task.name

  rdsRule.publicly_accessible == "yes"
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.rds_instance}}.publicly_accessible", [rdsRuleName]),
                "issueType":		  "MissingAttribute",
                "keyExpectedValue": "'community.aws.rds_instance.publicly_accessible' should be 'yes'",
                "keyActualValue": "'community.aws.rds_instance.publicly_accessible' is 'no'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}