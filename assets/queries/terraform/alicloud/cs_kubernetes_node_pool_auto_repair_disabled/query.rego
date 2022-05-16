package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_cs_kubernetes_node_pool[name]
	
	auto_repair := resource.management.auto_repair 
    auto_repair == false
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_cs_kubernetes_node_pool[%s].resource.management.auto_repair ",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("For the resource alicloud_cs_kubernetes_node_pool[%s] to have 'auto_repair' set to true.", [name]),
		"keyActualValue": sprintf("The resource alicloud_cs_kubernetes_node_pool[%s] has 'auto_repair' set to false.", [name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_cs_kubernetes_node_pool", name, "management", "auto_repair"], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_cs_kubernetes_node_pool[name]
    not common_lib.valid_key(resource, "management")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_cs_kubernetes_node_pool[%s]",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("For the resource alicloud_cs_kubernetes_node_pool[%s] to have a 'management' block containing 'auto_repair' set to true.", [name]),
		"keyActualValue": sprintf("The resource alicloud_cs_kubernetes_node_pool[%s] does not have a 'management' block.", [name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_cs_kubernetes_node_pool", name], []),
	}
}

CxPolicy[result] {

	resource := input.document[i].resource.alicloud_cs_kubernetes_node_pool[name]
    not common_lib.valid_key(resource.management, "auto_repair")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_cs_kubernetes_node_pool[%s].management",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("For the resource alicloud_cs_kubernetes_node_pool[%s] to have a 'management' block containing 'auto_repair' set to true.", [name]),
		"keyActualValue": sprintf("The resource alicloud_cs_kubernetes_node_pool[%s] has a 'management' block but it doesn't contain 'auto_repair' ", [name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_cs_kubernetes_node_pool", name, "management"], []),
	}
}
