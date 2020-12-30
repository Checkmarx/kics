package Cx

CxPolicy [ result ] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    task["community.aws.ecs_taskdefinition"].network_mode != "awsvpc"

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.ecs_taskdefinition}}.network_mode", [task.name]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "'community.aws.ecs_taskdefinition.network_mode' is 'awsvpc'",
                "keyActualValue": 	sprintf("'community.aws.ecs_taskdefinition.network_mode' is '%s'", [task["community.aws.ecs_taskdefinition"].network_mode])
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
