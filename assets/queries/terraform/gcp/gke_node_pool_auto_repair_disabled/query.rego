package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_node_pool[name]
    mgmt := resource.management
    mgmt.auto_repair == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_node_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s].management.auto_repair", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair should be true", [name]),
        "keyActualValue": sprintf("google_container_node_pool[%s].management.auto_repair is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name, "management", "auto_repair"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_container_node_pool[name]
    not common_lib.valid_key(resource, "management")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_node_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair should be true", [name]),
        "keyActualValue": sprintf("google_container_node_pool[%s].management is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name], []),
    }
}
