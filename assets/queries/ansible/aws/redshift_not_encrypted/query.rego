package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  redshiftCluster := task["community.aws.redshift"]
  clusterName := task.name
	
  object.get(redshiftCluster, "encrypted", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.redshift}}", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
                "keyActualValue":   "community.aws.redshift.encrypted is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  redshiftCluster := task["community.aws.redshift"]
  clusterName := task.name
  not isAnsibleTrue(redshiftCluster.encrypted)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{community.aws.redshift}}.encrypted", [clusterName]),
              "issueType":        "WrongValue",
              "keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
              "keyActualValue":   "community.aws.redshift.encrypted is set to false"
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