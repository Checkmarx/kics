package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  azureMonitor := task["azure_rm_monitorlogprofile"]
  monitorName := task.name
  categories := azureMonitor.categories
  elems = ["Write", "Action", "Delete"]
  elem := elems[k]
  not containsCategories(categories, elem)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.categories", [monitorName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_monitorlogprofile.categories should have all categories, Write, Action and Delete",
                "keyActualValue":   "azure_rm_monitorlogprofile.categories does not have all categories, Write, Action and Delete"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  azureMonitor := task["azure_rm_monitorlogprofile"]
  monitorName := task.name
  object.get(azureMonitor,"categories","undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}", [monitorName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "azure_rm_monitorlogprofile.categories is defined",
                "keyActualValue":   "azure_rm_monitorlogprofile.categories is undefined"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

containsCategories(categories, elem) = true {
  lower(categories[_]) == lower(elem)
} else = false { true }
