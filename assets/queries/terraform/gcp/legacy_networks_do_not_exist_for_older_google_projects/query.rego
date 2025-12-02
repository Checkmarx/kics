package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# field project defined inside the google_compute_network resource
CxPolicy[result] {
    project := input.document[i].resource.google_project[name_gp]
    compute_network := input.document[i].resource.google_compute_network[name_comp_network]

    associated_project := split(compute_network.project, ".")[1]
    associated_project == name_gp

    res := get_res(compute_network, name_comp_network)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_compute_network",
        "resourceName": tf_lib.get_resource_name(compute_network, name_comp_network),
        "searchKey": res["sk"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"]
    }
}

# field project not defined inside the google_compute_network_resource, so, in that case it uses the provider
CxPolicy[result] {
    project := input.document[i].resource.google_project[name_gp]
    compute_network := input.document[i].resource.google_compute_network[name_comp_network]

    not common_lib.valid_key(compute_network, "project")
    
    provider := input.document[i].provider[provider_name]

    associated_project := get_provider_res(provider, provider_name)
    project.project_id == associated_project

    res := get_res(compute_network, name_comp_network)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_compute_network",
        "resourceName": tf_lib.get_resource_name(compute_network, name_comp_network),
        "searchKey": res["sk"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"]
    }
}

get_res(resource, name_comp_network) = res {
    not common_lib.valid_key(resource, "auto_create_subnetworks")

    res := {
        "sk": sprintf("google_compute_network[%s]", [name_comp_network]),
        "it": "MissingAttribute",
        "kev": "'auto_create_subnetworks' should be defined to false",
        "kav": "'auto_create_subnetworks' is not defined",
        "sl": common_lib.build_search_line(["resource", "google_compute_network", name_comp_network], []),
    }
} else = res {
    resource.auto_create_subnetworks == true

    res := {
        "sk": sprintf("google_compute_network[%s].auto_create_subnetworks", [name_comp_network]),
        "it": "IncorrectValue",
        "kev": "'auto_create_subnetworks' should be defined to false",
        "kav": "'auto_create_subnetworks' is defined to true",
        "sl": common_lib.build_search_line(["resource", "google_compute_network", name_comp_network, "auto_create_subnetwork"], []),
    }
}

get_provider_res(provider, provider_name) = project_id {
    provider_name == "google"
    project_id := provider.project
} else = project_id {
    provider_name == "google-beta"
    project_id := provider.project
}