package Cx

# REGLA 1: 'workload_metadata_config' ausente en google_container_cluster
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    not resource.node_config.workload_metadata_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'workload_metadata_config' should be defined with mode 'GKE_METADATA'",
        "keyActualValue": "'workload_metadata_config' is missing",
    }
}

# REGLA 2: 'workload_metadata_config' ausente en google_container_node_pool
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    not resource.node_config.workload_metadata_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'workload_metadata_config' should be defined with mode 'GKE_METADATA'",
        "keyActualValue": "'workload_metadata_config' is missing",
    }
}

# REGLA 3: Modo incorrecto en google_container_cluster
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    resource.node_config.workload_metadata_config.mode != "GKE_METADATA"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config.workload_metadata_config.mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'mode' should be set to 'GKE_METADATA'",
        "keyActualValue": sprintf("'mode' is set to '%s'", [resource.node_config.workload_metadata_config.mode]),
    }
}

# REGLA 4: Modo incorrecto en google_container_node_pool
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    resource.node_config.workload_metadata_config.mode != "GKE_METADATA"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config.workload_metadata_config.mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'mode' should be set to 'GKE_METADATA'",
        "keyActualValue": sprintf("'mode' is set to '%s'", [resource.node_config.workload_metadata_config.mode]),
    }
}