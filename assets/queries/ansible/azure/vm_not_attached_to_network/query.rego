package Cx

CxPolicy [ result ] {
  	document := input.document[i]
  	task := getTasks(document)[t]["azure_rm_virtualmachine"]

  	object.get(task, "network_interface_names", "undefined") == "undefined"
    object.get(task, "network_interfaces", "undefined") == "undefined"
    
	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{azure_rm_virtualmachine}}", [task.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'network_interface_names' is defined",
                "keyActualValue": 	"'network_interface_names' is undefined"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}