package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  azureMonitor := task["azure_rm_monitorlogprofile"]
  monitorName := task.name
  retentionPolicy := azureMonitor.retention_policy
  not isAnsibleTrue(retentionPolicy.enabled)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.retention_policy.enabled", [monitorName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.enabled is true or yes",
                "keyActualValue":   "azure_rm_monitorlogprofile.retention_policy.enabled is false or no"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  azureMonitor := task["azure_rm_monitorlogprofile"]
  monitorName := task.name
  retentionPolicy := azureMonitor.retention_policy
  isAnsibleTrue(retentionPolicy.enabled)
  retentionPolicy.days <= 90

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.retention_policy.days", [monitorName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.days is greater than 90 days",
                "keyActualValue":   "azure_rm_monitorlogprofile.retention_policy.days is lesser than 90 days"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  azureMonitor := task["azure_rm_monitorlogprofile"]
  monitorName := task.name
  object.get(azureMonitor,"retention_policy","undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}", [monitorName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy is defined",
                "keyActualValue":   "azure_rm_monitorlogprofile.retention_policy is undefined"
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
