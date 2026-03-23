package Cx

import data.generic.terraform as tf_lib

# RULE 1: 'database_encryption' block missing.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    not cluster.database_encryption

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(cluster, name),
        "searchKey": sprintf("google_container_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'database_encryption' block should be defined",
        "keyActualValue": "'database_encryption' block is missing",
    }
}

# RULE 2: Incorrect encryption state (DECRYPTED).
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    cluster.database_encryption.state != "ENCRYPTED"

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(cluster, name),
        "searchKey": sprintf("google_container_cluster[%s].database_encryption.state", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'state' should be set to 'ENCRYPTED'",
        "keyActualValue": sprintf("'state' is set to '%s'", [cluster.database_encryption.state]),
    }
}

# RULE 3: State is ENCRYPTED but key name (key_name) is missing.
CxPolicy[result] {
    doc := input.document[i]
    cluster := doc.resource.google_container_cluster[name]

    cluster.database_encryption.state == "ENCRYPTED"

    key_name := object.get(cluster.database_encryption, "key_name", "")
    key_name == ""

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(cluster, name),
        "searchKey": sprintf("google_container_cluster[%s].database_encryption.key_name", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'key_name' should be defined with a valid KMS key ID",
        "keyActualValue": "'key_name' is missing or empty",
    }
}
