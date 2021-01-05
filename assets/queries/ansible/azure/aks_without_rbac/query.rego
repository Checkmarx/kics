package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    object.get(task["azure_rm_aks"], "enable_rbac", "undefined") == "undefined"

    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{azure_rm_aks}}", [task.name]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  "azure_rm_aks.enable_rbac is set",
        "keyActualValue": 	 "azure_rm_aks.enable_rbac is undefined"
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    not isYesOrTrue(task["azure_rm_aks"].enable_rbac)

    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{azure_rm_aks}}.enable_rbac", [task.name]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  "azure_rm_aks.enable_rbac is set to 'yes' or 'true'",
        "keyActualValue": 	 "azure_rm_aks.enable_rbac is not set to 'yes' or 'true'"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isYesOrTrue(attribute) {
   options := {"yes", true}
   attribute == options[j]
}
