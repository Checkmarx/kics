package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_resources := {"google_container_cluster", "google_container_node_pool"}

CxPolicy[result] {
    resource := input.document[i].resource[supported_resources[res_index]][name]

    resource.node_config.shielded_instance_config.enable_integrity_monitoring == false

    result := {
        "documentId": input.document[i].id,
        "resourceType": supported_resources[res_index],
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("%s[%s].node_config.shielded_instance_config.enable_integrity_monitoring", [supported_resources[res_index], name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'node_config.shielded_instance_config.enable_integrity_monitoring' should be defined to 'true'",
        "keyActualValue":  "'node_config.shielded_instance_config.enable_integrity_monitoring' is not defined to 'true'",
        "searchLine": common_lib.build_search_line(["resource", supported_resources[res_index], name, "node_config", "shielded_instance_config", "enable_integrity_monitoring"], [])
    }
}