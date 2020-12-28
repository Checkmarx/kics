package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
  
  object.get(cluster, "master_auth", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
  
  object.get(cluster.master_auth, "client_certificate_config", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
  
  isAnsibleFalse(cluster.master_auth.client_certificate_config.issue_client_certificate)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth.client_certificate_config.issue_client_certificate", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.password is true",
                "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.password is false"
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