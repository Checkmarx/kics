package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'metadata' block does not exist.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    not instance.metadata

    result := {
        "documentId": doc.id,
        "resourceType": "google_compute_instance",
        "resourceName": tf_lib.get_resource_name(instance, name),
        "searchKey": sprintf("google_compute_instance[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'metadata' block should be defined and contain 'google-logging-enabled'",
        "keyActualValue": "'metadata' block is missing",
    }
}

# RULE 2: The 'metadata' block exists but is missing the 'google-logging-enabled' key.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    instance.metadata
    not instance.metadata["google-logging-enabled"]

    result := {
        "documentId": doc.id,
        "resourceType": "google_compute_instance",
        "resourceName": tf_lib.get_resource_name(instance, name),
        "searchKey": sprintf("google_compute_instance[%s].metadata", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "metadata"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'google-logging-enabled' should be defined within metadata",
        "keyActualValue": "'google-logging-enabled' is missing in metadata",
    }
}

# RULE 3: The key exists but its value is 'false'.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    val := instance.metadata["google-logging-enabled"]
    val == "false"

    result := {
        "documentId": doc.id,
        "resourceType": "google_compute_instance",
        "resourceName": tf_lib.get_resource_name(instance, name),
        "searchKey": sprintf("google_compute_instance[%s].metadata.google-logging-enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "metadata", "google-logging-enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'google-logging-enabled' should be set to 'true'",
        "keyActualValue": "'google-logging-enabled' is set to 'false'",
    }
}
