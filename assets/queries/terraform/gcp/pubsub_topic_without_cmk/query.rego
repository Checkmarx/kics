package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_pubsub_topic[name]
    not common_lib.valid_key(resource, "kms_key_name")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_pubsub_topic",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_pubsub_topic[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_pubsub_topic[%s].kms_key_name should be defined", [name]),
        "keyActualValue": sprintf("google_pubsub_topic[%s].kms_key_name is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", name], []),
    }
}
