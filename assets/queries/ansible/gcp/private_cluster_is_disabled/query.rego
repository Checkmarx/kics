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
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config is defined", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config is undefined", [clusterName])
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
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_nodes is defined", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_nodes is undefined", [clusterName])
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
                "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_endpoint is defined", [clusterName]),
                "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_endpoint is undefined", [clusterName])
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
              "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_endpoint is true", [clusterName]),
              "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_endpoint is false", [clusterName])
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
              "keyExpectedValue": sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_nodes is true", [clusterName]),
              "keyActualValue":   sprintf("google.cloud.gcp_container_cluster[%s].private_cluster_config.enable_private_nodes is false", [clusterName])
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