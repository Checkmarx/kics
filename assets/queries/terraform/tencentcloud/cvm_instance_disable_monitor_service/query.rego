package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.tencentcloud_instance[name]
    resource.disable_monitor_service == true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "tencentcloud_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_instance[%s].disable_monitor_service", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("[%s] 'disable_monitor_service' should be set to false", [name]),
        "keyActualValue": sprintf("[%s] 'disable_monitor_service' is true", [name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_instance", name, "disable_monitor_service"], []),
    }
}
