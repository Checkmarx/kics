package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]
    resource.logging_service == "none"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].logging_service", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_container_cluster[%s].logging_service should be logging.googleapis.com/kubernetes", [name]),
        "keyActualValue": sprintf("google_container_cluster[%s].logging_service is none", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "logging_service"], []),
    }
}
