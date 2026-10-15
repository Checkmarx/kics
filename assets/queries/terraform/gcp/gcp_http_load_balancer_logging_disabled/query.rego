package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: Bloque 'log_config' missing.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    not bs.log_config

    result := {
        "documentId": doc.id,
        "resourceType": "google_compute_backend_service",
        "resourceName": tf_lib.get_resource_name(bs, name),
        "searchKey": sprintf("google_compute_backend_service[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_compute_backend_service", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "log_config should be defined with enable set to true",
        "keyActualValue": "log_config is missing",
    }
}

# RULE 2: Bloque 'log_config' Exists but 'enable' es false.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    bs.log_config.enable == false

    result := {
        "documentId": doc.id,
        "resourceType": "google_compute_backend_service",
        "resourceName": tf_lib.get_resource_name(bs, name),
        "searchKey": sprintf("google_compute_backend_service[%s].log_config.enable", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_compute_backend_service", name, "log_config", "enable"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "log_config.enable should be set to true",
        "keyActualValue": "log_config.enable is set to false",
    }
}
