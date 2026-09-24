package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_redis_instance[name]
    not common_lib.valid_key(resource, "auth_enabled")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_redis_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_redis_instance[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("google_redis_instance[%s].auth_enabled should be true", [name]),
        "keyActualValue": sprintf("google_redis_instance[%s].auth_enabled is not defined (defaults to false)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.google_redis_instance[name]
    resource.auth_enabled == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_redis_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_redis_instance[%s].auth_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_redis_instance[%s].auth_enabled should be true", [name]),
        "keyActualValue": sprintf("google_redis_instance[%s].auth_enabled is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "auth_enabled"], []),
    }
}
