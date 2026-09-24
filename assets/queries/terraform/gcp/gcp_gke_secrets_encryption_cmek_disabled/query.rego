package Cx

import data.generic.common as common_lib
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
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
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
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "database_encryption", "state"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'state' should be set to 'ENCRYPTED'",
        "keyActualValue": sprintf("'state' is set to '%s'", [cluster.database_encryption.state]),
    }
}

# RULE 3: State is ENCRYPTED but key name (key_name) is missing.
# searchLine points to database_encryption block since key_name is absent.
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
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "database_encryption"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'key_name' should be defined with a valid KMS key ID",
        "keyActualValue": "'key_name' is missing or empty",
    }
}
