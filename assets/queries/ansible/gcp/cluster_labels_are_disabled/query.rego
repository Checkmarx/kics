package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  object.get(cluster, "resource_labels", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.resource_labels", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.resource_labels is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.resource_labels is undefined"
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
	answer == true
}