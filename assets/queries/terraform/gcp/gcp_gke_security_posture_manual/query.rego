package Cx

# REGLA 1: Bloque 'security_posture_config' ausente.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    not cluster.security_posture_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'security_posture_config' block should be defined with mode 'BASIC' or 'ENTERPRISE'",
        "keyActualValue": "'security_posture_config' block is missing",
    }
}

# REGLA 2: Bloque presente, pero 'mode' es 'DISABLED'.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    cluster.security_posture_config.mode == "DISABLED"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_container_cluster.%s.security_posture_config.mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'mode' should be set to 'BASIC' or 'ENTERPRISE'",
        "keyActualValue": "'mode' is set to 'DISABLED'",
    }
}