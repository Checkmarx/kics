package Cx

import data.generic.terraform as tf_lib

# RULE 1: Service Account missing in google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    not resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'service_account' should be explicitly defined in node_config",
        "keyActualValue": "'service_account' is missing, defaulting to the Compute Engine default service account",
    }
}

# RULE 2: Service Account missing in google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    not resource.node_config.service_account

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_node_pool",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s].node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'service_account' should be explicitly defined in node_config",
        "keyActualValue": "'service_account' is missing, defaulting to the Compute Engine default service account",
    }
}
