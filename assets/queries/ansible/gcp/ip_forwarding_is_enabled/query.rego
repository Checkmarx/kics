package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name

  isAnsibleTrue(instance.can_ip_forward)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.can_ip_forward", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.can_ip_forward is false",
                "keyActualValue":   "google.cloud.gcp_compute_instance.can_ip_forward is true"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
} 

isAnsibleTrue(answer) {
 	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}