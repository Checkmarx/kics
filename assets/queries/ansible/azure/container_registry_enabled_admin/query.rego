package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  containerReg := task["azure.azcollection.azure_rm_containerregistry"]
  containerRegName := task.name

  isAnsibleTrue(containerReg.admin_user_enabled)

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure.azcollection.azure_rm_containerregistry}}.admin_user_enabled", [containerRegName]),
                "issueType":        "WrongValue",
                "keyExpectedValue": "azure.azcollection.azure_rm_containerregistry.admin_user_enabled should be false or undefined (defaults to false)",
                "keyActualValue":   "azure.azcollection.azure_rm_containerregistry.admin_user_enabled is true"
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
