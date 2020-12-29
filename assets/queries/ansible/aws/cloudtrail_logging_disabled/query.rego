package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    task["community.aws.cloudtrail"].enable_logging == false


    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging is true", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging is false", [task.name])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
