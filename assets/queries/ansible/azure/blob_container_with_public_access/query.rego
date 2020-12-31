package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    hasPublicAccess(task["azure_rm_storageblob"].public_access)

    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_storageblob}}.public_access", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "azure_rm_storageblob.public_access is not set",
        "keyActualValue": "azure_rm_storageblob.public_access is equal to 'blob' or 'container'"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

hasPublicAccess(access) {
 	lower(access) == "blob"
}

hasPublicAccess(access) {
 	lower(access) == "container"
}