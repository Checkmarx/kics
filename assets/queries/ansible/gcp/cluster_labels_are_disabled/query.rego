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
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is defined", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is undefined", [clusterName])
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  cluster.resource_labels == null

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.resource_labels", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is not null", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is null", [clusterName])
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name

  count(cluster.resource_labels) == 0

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.resource_labels", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is not empty", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].resource_labels is empty", [clusterName])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
