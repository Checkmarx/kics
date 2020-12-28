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

  object.get(cluster.master_auth, "username", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.username is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.username is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  object.get(cluster.master_auth, "password", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.password is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.password is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  check_size(cluster.master_auth.username)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth.username", [clusterName]),
              "issueType":        "IncorrectValue",
              "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.username is not empty",
              "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.username is empty"
            }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  check_size(cluster.master_auth.password)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth.password", [clusterName]),
              "issueType":        "IncorrectValue",
              "keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.password is not empty",
              "keyActualValue":   "google.cloud.gcp_container_cluster.master_auth.password is empty"
            }
}

check_size(val){
  count(val) == 0
}

check_size(val){
  val == null
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}