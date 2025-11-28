package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# this query checks a value in a field that was removed on the version 3.0.0 of the resource
CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]

    resource.addons_config.kubernetes_dashboard.disabled == false

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].addons_config.kubernetes_dashboard.disabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'kuberneters_dashboard' should not be enabled inside the 'addons_config block'",
        "keyActualValue": "'kuberneters_dashboard' is enabled inside the 'addons_config block'",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "addons_config", "kubernetes_dashboard", "disabled"], [])
    }
}