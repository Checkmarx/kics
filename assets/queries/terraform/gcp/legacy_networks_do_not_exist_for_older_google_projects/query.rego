package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# field project defined inside the google_compute_network_resource
CxPolicy[result] {
    project := input.document[i].resource.google_project[name_gp]
    compute_network := input.document[i].resource.google_compute_network[name_comp_network]

    associated_project := split(compute_network.project, ".")[1]
    associated_project == name_gp

    compute_network.auto_create_subnetworks

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_compute_network",
        "resourceName": tf_lib.get_resource_name(compute_network, name_comp_network),
        "seachKey": sprintf("google_compute_network[%s].auto_create_subnetworks", [name_comp_network]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'auto_create_subnetworks' should not be defined to true",
        "keyActualValue": "'auto_create_subnetworks' is defined to true",
        "searchLine": common_lib.build_search_line(["resource", "google_compute_network", name_comp_network, "auto_create_subnetworks"], [])
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

    compute_network.auto_create_subnetworks

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_compute_network",
        "resourceName": tf_lib.get_resource_name(compute_network, name_comp_network),
        "seachKey": sprintf("google_compute_network[%s].auto_create_subnetworks", [name_comp_network]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'auto_create_subnetworks' should not be defined to true",
        "keyActualValue": "'auto_create_subnetworks' is defined to true",
        "searchLine": common_lib.build_search_line(["resource", "google_compute_network", name_comp_network, "auto_create_subnetworks"], [])
    }
}

get_provider_res(provider, provider_name) = project_id {
    provider_name == "google"
    project_id := provider.project
} else = project_id {
    provider_name == "google-beta"
    project_id := provider.project
}