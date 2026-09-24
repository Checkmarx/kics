package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_redis_instance[name]
    not common_lib.valid_key(resource, "transit_encryption_mode")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_redis_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_redis_instance[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_redis_instance[%s].transit_encryption_mode should be SERVER_AUTHENTICATION", [name]),
        "keyActualValue": sprintf("google_redis_instance[%s].transit_encryption_mode is not defined (defaults to DISABLED)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_redis_instance[name]
    resource.transit_encryption_mode == "DISABLED"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_redis_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_redis_instance[%s].transit_encryption_mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_redis_instance[%s].transit_encryption_mode should be SERVER_AUTHENTICATION", [name]),
        "keyActualValue": sprintf("google_redis_instance[%s].transit_encryption_mode is DISABLED", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "transit_encryption_mode"], []),
    }
}
