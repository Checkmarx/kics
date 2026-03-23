package Cx

import data.generic.terraform as tf_lib

# RULE 1: 'security_posture_config' block missing.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    not cluster.security_posture_config

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(cluster, name),
        "searchKey": sprintf("google_container_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'security_posture_config' block should be defined with mode 'BASIC' or 'ENTERPRISE'",
        "keyActualValue": "'security_posture_config' block is missing",
    }
}

# RULE 2: Block present, but 'mode' is 'DISABLED'.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    cluster.security_posture_config.mode == "DISABLED"

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(cluster, name),
        "searchKey": sprintf("google_container_cluster[%s].security_posture_config.mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'mode' should be set to 'BASIC' or 'ENTERPRISE'",
        "keyActualValue": "'mode' is set to 'DISABLED'",
    }
}
