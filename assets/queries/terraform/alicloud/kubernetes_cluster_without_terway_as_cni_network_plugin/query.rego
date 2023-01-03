package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_cs_kubernetes[name]

    not common_lib.valid_key(resource, "pod_vswitch_ids")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_cs_kubernetes",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_cs_kubernetes[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_cs_kubernetes[%s].pod_vswitch_ids should be defined and not null",[name]),
		"keyActualValue": sprintf("alicloud_cs_kubernetes[%s].pod_vswitch_ids is undefined or  null",[name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_cs_kubernetes", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_cs_kubernetes[name]

    not addons_with_terway(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_cs_kubernetes",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_cs_kubernetes[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_cs_kubernetes[%s].addons specifies the terway-eniip",[name]),
		"keyActualValue": sprintf("alicloud_cs_kubernetes[%s].addons does not specify the terway-eniip",[name]),
        "searchLine": common_lib.build_search_line(["resource", "alicloud_cs_kubernetes", name], []),
	}
}


addons_with_terway(resource) {
	resource.addons[_].name == "terway-eniip"
} else {
	resource.addons.name == "terway-eniip"
}
