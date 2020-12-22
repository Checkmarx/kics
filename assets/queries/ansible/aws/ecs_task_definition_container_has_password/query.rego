package Cx

CxPolicy [ result ] {
	password := ["password", "PASSWORD"]
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cont := task["community.aws.ecs_taskdefinition"].containers[j]
  not object.get(cont.env[_], password[s], "undefined") == "undefined"


	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{community.aws.ecs_taskdefinition}}.containers.name={{%s}}.env.%s", [task.name, cont.name, password[s]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "'community.aws.ecs_taskdefinition.containers.env' doesn't have 'password' value",
                "keyActualValue": 	"'community.aws.ecs_taskdefinition.containers.env' has 'password' value"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

