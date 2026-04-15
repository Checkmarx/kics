package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: 'sandbox_config' block missing in google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    not resource.node_config.sandbox_config

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'sandbox_config' should be defined with sandbox_type 'gvisor'",
        "keyActualValue": "'sandbox_config' is missing",
    }
}

# RULE 2: 'sandbox_config' block missing in google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    not resource.node_config.sandbox_config

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_node_pool",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s].node_config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'sandbox_config' should be defined with sandbox_type 'gvisor'",
        "keyActualValue": "'sandbox_config' is missing",
    }
}

# RULE 3: Incorrect sandbox_type in google_container_cluster.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_cluster[name]

    resource.node_config.sandbox_config.sandbox_type != "gvisor"

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].node_config.sandbox_config.sandbox_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'sandbox_type' should be 'gvisor'",
        "keyActualValue": sprintf("'sandbox_type' is set to '%s'", [resource.node_config.sandbox_config.sandbox_type]),
    }
}

# RULE 4: Incorrect sandbox_type in google_container_node_pool.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.google_container_node_pool[name]

    resource.node_config.sandbox_config.sandbox_type != "gvisor"

    result := {
        "documentId": doc.id,
        "resourceType": "google_container_node_pool",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s].node_config.sandbox_config.sandbox_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'sandbox_type' should be 'gvisor'",
        "keyActualValue": sprintf("'sandbox_type' is set to '%s'", [resource.node_config.sandbox_config.sandbox_type]),
    }
}
