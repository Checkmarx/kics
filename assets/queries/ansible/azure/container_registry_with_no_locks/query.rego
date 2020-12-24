package Cx

CxPolicy [ result ] {
	document := input.document[i]
  	taskContainerRegistry := getTasks(document)[t]["azure_rm_containerregistry"]
  	taskLock := getTasks(document)[t2]["azure_rm_lock"]
  
    taskContainerRegistry.resource_group != taskLock.resource_group
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_containerregistry}}.resource_group", [taskContainerRegistry.name]),
                "issueType":		  "MissingAttribute",
                "keyExpectedValue": "'azure_rm_containerregistry.resource_group' has lock associated",
                "keyActualValue": "'azure_rm_containerregistry.resource_group' has no lock associated"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}