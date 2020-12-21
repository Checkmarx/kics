package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
	
  object.get(cluster, "private_cluster_config", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.private_cluster_config is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.private_cluster_config is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
	
  object.get(cluster.private_cluster_config, "enable_private_nodes", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_nodes is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_nodes is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
	
  object.get(cluster.private_cluster_config, "enable_private_endpoint", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_endpoint is defined",
                "keyActualValue":   "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_endpoint is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
  not isAnsibleTrue(cluster.private_cluster_config.enable_private_endpoint)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config.enable_private_endpoint", [clusterName]),
              "issueType":        "IncorrectValue",
              "keyExpectedValue": "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_endpoint is true",
              "keyActualValue":   "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_endpoint is false"
            }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cluster := task["google.cloud.gcp_container_cluster"]
  clusterName := task.name
  not isAnsibleTrue(cluster.private_cluster_config.enable_private_nodes)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.private_cluster_config.enable_private_nodes", [clusterName]),
              "issueType":        "IncorrectValue",
              "keyExpectedValue": "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_nodes is true",
              "keyActualValue":   "google.cloud.gcp_container_cluster.private_cluster_config.enable_private_nodes is false"
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