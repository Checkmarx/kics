package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_node_pool[name]
    mgmt := resource.management
    mgmt.auto_upgrade == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_node_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_node_pool[%s].management.auto_upgrade", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_upgrade should be true", [name]),
        "keyActualValue": sprintf("google_container_node_pool[%s].management.auto_upgrade is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name, "management", "auto_upgrade"], []),
    }
}
