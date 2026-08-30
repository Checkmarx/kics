package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    not common_lib.valid_key(resource, "private_cluster_config")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_container_cluster[%s].private_cluster_config.enable_private_nodes should be true", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].private_cluster_config is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    pcc := resource.private_cluster_config
    pcc.enable_private_nodes == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].private_cluster_config.enable_private_nodes", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_cluster[%s].private_cluster_config.enable_private_nodes should be true", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].private_cluster_config.enable_private_nodes is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "private_cluster_config", "enable_private_nodes"], []),
    }
}
