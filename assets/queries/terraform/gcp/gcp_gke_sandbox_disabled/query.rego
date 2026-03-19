package Cx

# REGLA 1: Bloque 'sandbox_config' ausente en google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    not resource.node_config.sandbox_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'sandbox_config' should be defined with sandbox_type 'gvisor'",
        "keyActualValue": "'sandbox_config' is missing",
    }
}

# REGLA 2: Bloque 'sandbox_config' ausente en google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    not resource.node_config.sandbox_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'sandbox_config' should be defined with sandbox_type 'gvisor'",
        "keyActualValue": "'sandbox_config' is missing",
    }
}

# REGLA 3: sandbox_type incorrecto en google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    resource.node_config.sandbox_config.sandbox_type != "gvisor"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.node_config.sandbox_config.sandbox_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'sandbox_type' should be 'gvisor'",
        "keyActualValue": sprintf("'sandbox_type' is set to '%s'", [resource.node_config.sandbox_config.sandbox_type]),
    }
}

# REGLA 4: sandbox_type incorrecto en google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    resource.node_config.sandbox_config.sandbox_type != "gvisor"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_node_pool.%s.node_config.sandbox_config.sandbox_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'sandbox_type' should be 'gvisor'",
        "keyActualValue": sprintf("'sandbox_type' is set to '%s'", [resource.node_config.sandbox_config.sandbox_type]),
    }
}