package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config[_]

    common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

	masterConfig.public_ip_assigned == true
	masterConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].public_ip_assigned", [name, _]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", tostring(_), "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].public_ip_assigned should equal 'false'", [name, _]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].public_ip_assigned is equal 'true'", [name, _]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config[_]

	not common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

	masterConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].internet_max_bandwidth_out", [name, _]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", tostring(_), "internet_max_bandwidth_out"], []),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].public_ip_assigned should equal '0' or undefined", [name, _]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[%d].public_ip_assigned inot equal to '0'", [name, _]),	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config[_]

    common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

	workerConfig.public_ip_assigned == true
	workerConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].public_ip_assigned", [name, _]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", tostring(_), "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].public_ip_assigned should equal 'false'", [name, _]),
        "keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].public_ip_assigned is equal 'true'", [name, _]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config[_]

    not common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

	workerConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].internet_max_bandwidth_out", [name, _]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", tostring(_), "internet_max_bandwidth_out"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].public_ip_assigned should equal '0' or undefined", [name, _]),
        "keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[%d].public_ip_assigned inot equal to '0'", [name, _]),
	}
}
