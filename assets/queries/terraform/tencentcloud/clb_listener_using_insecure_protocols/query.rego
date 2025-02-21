package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

insecure_protocols := {"TCP", "UDP", "HTTP"}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_clb_listener[name]
    protocolCheck := resource.protocol
    insecure_protocols[protocolCheck]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_clb_listener",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_clb_listener[%s].protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_clb_listener[%s].protocol[%s] should not be an insecure protocol", [name, protocolCheck]),
		"keyActualValue": sprintf("tencentcloud_clb_listener[%s].protocol[%s] is an insecure protocol", [name, protocolCheck]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_clb_listener", name, "protocol"], []),
	}
}
