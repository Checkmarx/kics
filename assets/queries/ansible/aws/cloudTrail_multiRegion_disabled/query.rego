package Cx

CxPolicy [ result ] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleFalse(task["community.aws.cloudtrail"].is_multi_region_trail)


	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail is true", [task.name]),
                "keyActualValue": 	sprintf("name={{%s}}.{{community.aws.cloudtrail}}.is_multi_region_trail is false", [task.name]),
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isAnsibleFalse(answer) {
    lower(answer) == "no"
} else {
    lower(answer) == "false"
} else {
    answer == false
}
