package Cx

CxPolicy [ result ]  {
	document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

  	taskContainerRegistry := task["azure_rm_containerregistry"]

	not checkLocks(taskContainerRegistry)


		result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_containerregistry}}.resource_group", [task.name]),
                "issueType":		  "IncorrectValue",
                "keyExpectedValue": "'azure_rm_containerregistry.resource_group' lock used should referring to an one that exists",
                "keyActualValue": "'azure_rm_containerregistry.resource_group' lock used is referring to an one that doesn't exist"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

checkLocks(taskContainerRegistry) {
	document2 := input.document[x]
  	taskLock := getTasks(document2)[t2]["azure_rm_lock"]
	contains(taskLock, taskContainerRegistry.resource_group)
}

contains(taskLock, taskContainerRegistry) {
	taskLock.resource_group == taskContainerRegistry
}
