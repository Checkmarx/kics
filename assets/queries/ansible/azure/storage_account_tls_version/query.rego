package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    not task["azure_rm_storageaccount"].minimum_tls_version == "TLS1_2"

    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.minimum_tls_version", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Storage Account is using the latest version of TLS encryption",
        "keyActualValue": "Storage Account is not using the latest version of TLS encryption"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
