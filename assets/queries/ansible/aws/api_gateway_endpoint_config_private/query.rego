package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  redshiftCluster := task["community.aws.aws_api_gateway"]
  redshiftCluster.endpoint_type == "PRIVATE"
  clusterName := task.name
	
      result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.aws_api_gateway}}.endpoint_type", [clusterName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "community.aws.aws_api_gateway.endpoint_type should be set to EDGE or REGIONAL",
                "keyActualValue":   "community.aws.aws_api_gateway.endpoint_type is PRIVATE"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}