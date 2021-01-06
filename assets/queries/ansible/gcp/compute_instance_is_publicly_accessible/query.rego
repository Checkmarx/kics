package Cx

CxPolicy [result ]  {
	document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]

  task["google.cloud.gcp_compute_instance"].network_interfaces[_].access_configs

  result := {
            "documentId": document.id,
        	  "searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.network_interfaces", [task.name]),
        	  "issueType": "IncorrectValue",
       	 	  "keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.network_interfaces.access_configs is not defined",
        	  "keyActualValue": "{{google.cloud.gcp_compute_instance}}.network_interfaces.access_configs is defined"
            }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook]
    count(result) != 0
}
