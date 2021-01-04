package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    storage := task["azure_rm_storageaccount"]

    object.get(storage, "minimum_tls_version", "undefined") == "undefined"

    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}", [task.name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("name=%s.{{azure_rm_storageaccount}}.minimum_tls_version is defined", [task.name]),
        "keyActualValue": sprintf("name=%s.{{azure_rm_storageaccount}}.minimum_tls_version is undefined", [task.name])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    tls_version := task["azure_rm_storageaccount"].minimum_tls_version
    not tls_version == "TLS1_2"

    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.minimum_tls_version", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("name=%s.{{azure_rm_storageaccount}} is using the latest version of TLS encryption", [task.name]),
        "keyActualValue": sprintf("name=%s.{{azure_rm_storageaccount}} is using version %s of TLS encryption", [task.name, tls_version])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
