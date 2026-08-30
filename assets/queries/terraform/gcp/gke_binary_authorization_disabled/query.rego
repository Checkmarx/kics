package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    not common_lib.valid_key(resource, "binary_authorization")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_container_cluster[%s].binary_authorization should be defined with evaluation_mode != DISABLED", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].binary_authorization is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    ba := resource.binary_authorization
    ba.evaluation_mode == "DISABLED"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].binary_authorization.evaluation_mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_cluster[%s].binary_authorization.evaluation_mode should be PROJECT_SINGLETON_POLICY_ENFORCE or POLICY_BINDINGS", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].binary_authorization.evaluation_mode is DISABLED", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "binary_authorization", "evaluation_mode"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    ba := resource.binary_authorization
    ba.enabled == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].binary_authorization.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_cluster[%s].binary_authorization.enabled should be true", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].binary_authorization.enabled is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "binary_authorization", "enabled"], []),
    }
}
