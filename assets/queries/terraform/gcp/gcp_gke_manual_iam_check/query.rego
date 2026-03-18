package Cx

# REGLA 1: Detección de SA personalizada en google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    sa := resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config.service_account", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Custom Service Account IAM roles should be verified as Read-Only",
        "keyActualValue": sprintf("Custom Service Account '%s' found. Manual IAM verification required.", [sa]),
    }
}

# REGLA 2: Detección de SA personalizada en google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    sa := resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config.service_account", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Custom Service Account IAM roles should be verified as Read-Only",
        "keyActualValue": sprintf("Custom Service Account '%s' found. Manual IAM verification required.", [sa]),
    }
}