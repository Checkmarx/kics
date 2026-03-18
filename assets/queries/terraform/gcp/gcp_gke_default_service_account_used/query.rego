package Cx

# REGLA 1: Service Account ausente en google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    not resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'service_account' should be explicitly defined in node_config",
        "keyActualValue": "'service_account' is missing, defaulting to the Compute Engine default service account",
    }
}

# REGLA 2: Service Account ausente en google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    not resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'service_account' should be explicitly defined in node_config",
        "keyActualValue": "'service_account' is missing, defaulting to the Compute Engine default service account",
    }
}