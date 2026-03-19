package Cx

# REGLA 1: Workload Identity no habilitado (Missing Attribute).
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    not cluster.workload_identity_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'workload_identity_config' should be enabled to support dedicated Service Accounts",
        "keyActualValue": "'workload_identity_config' is missing",
    }
}

# REGLA 2: Workload Identity habilitado (Verificación Manual de Bindings).
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    cluster.workload_identity_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.workload_identity_config", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Verify that workloads use dedicated Service Accounts (no shared SAs)",
        "keyActualValue": "Workload Identity is enabled. Manual verification of bindings required.",
    }
}