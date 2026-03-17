package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# this query checks a value in a field that was removed on the version 3.0.0 of the resource
CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]

    res := get_results(resource, name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res.sk,
        "issueType": res.it,
        "keyExpectedValue": res.kev,
        "keyActualValue": res.kav,
        "searchLine": res.sl
    }
}

get_results(resource, name) = res {
    not common_lib.valid_key(resource.addons_config, "kubernetes_dashboard")
    version_array := split(resource.min_master_version, ".")
    is_low_version(version_array)
    res := {
        "sk": sprintf("google_container_cluster[%s].addons_config", [name]),
        "it": "MissingAttribute",
        "kev": "'kubernetes_dashboard' should be defined and disabled inside the 'addons_config_version' block for GKE versions below 1.10",
        "kav": "'kubernetes_dashboard' is not defined inside the 'addons_config_version' block",
        "sl": common_lib.build_search_line(["resource", "google_container_cluster", name, "addons_config"], [])
    }
} else = res {
    not common_lib.valid_key(resource, "addons_config")
    version_array := split(resource.min_master_version, ".")
    is_low_version(version_array)
    res := {
        "sk": sprintf("google_container_cluster[%s]", [name]),
        "it": "MissingAttribute",
        "kev": "'kubernetes_dashboard' should be defined and disabled inside the 'addons_config_version' block for GKE versions below 1.10",
        "kav": "'addons_config' block is not defined with the 'kubernetes_dashboard' disabled",
        "sl": common_lib.build_search_line(["resource", "google_container_cluster", name], [])
    }
} else = res {
    resource.addons_config.kubernetes_dashboard.disabled == false
    res := {
        "sk": sprintf("google_container_cluster[%s].addons_config.kubernetes_dashboard.disabled", [name]),
        "it": "IncorrectValue",
        "kev": "'kuberneters_dashboard' should not be enabled inside the 'addons_config block'",
        "kav": "'kuberneters_dashboard' is enabled inside the 'addons_config block'",
        "sl": common_lib.build_search_line(["resource", "google_container_cluster", name, "addons_config", "kubernetes_dashboard", "disabled"], [])
    }
}

is_low_version(version_array) { # if we use comparisons with < or >, 1.10 will be considered lower than 1.8
    version_array[0] == "0"
} else {
    version_array[0] == "1"
    to_number(version_array[1]) < 10
}