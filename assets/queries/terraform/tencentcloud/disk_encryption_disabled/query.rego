package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	resource := input.document[i].resource.tencentcloud_cbs_storage[name]
    resource.encrypt == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_cbs_storage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_cbs_storage[%s].encrypt", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] has encryption set to true", [name]),
		"keyActualValue": sprintf("[%s] has encryption set to false", [name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_cbs_storage", name, "encrypt"], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.tencentcloud_cbs_storage[name]
    not common_lib.valid_key(resource, "encrypt")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_cbs_storage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_cbs_storage[%s]",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s] has encryption enabled",[name]),
		"keyActualValue": sprintf("[%s] does not have encryption enabled",[name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_cbs_storage", name], []),
	}
}

