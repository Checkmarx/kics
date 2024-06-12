package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	master_config := resource.master_config[_]

	common_lib.valid_key(master_config, "public_ip_assigned")
	common_lib.valid_key(master_config, "internet_max_bandwidth_out")

	master_config.public_ip_assigned == true
	master_config.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[_].public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", "_", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'master_config[_].public_ip_assigned' should equal 'false'",
		"keyActualValue": "'master_config[_].public_ip_assigned' is equal 'true'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	master_config := resource.master_config[_]

	not common_lib.valid_key(master_config, "public_ip_assigned")
	common_lib.valid_key(master_config, "internet_max_bandwidth_out")

	master_config.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config[_].public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", "_", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'master_config[_].public_ip_assigned' should equal 'false'",
		"keyActualValue": "'master_config[_].public_ip_assigned' is equal 'true' or undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	worker_config := resource.worker_config[_]

    common_lib.valid_key(worker_config, "public_ip_assigned")
    common_lib.valid_key(worker_config, "internet_max_bandwidth_out")

	worker_config.public_ip_assigned == true
	worker_config.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[_].public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", "_", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'worker_config[_].public_ip_assigned' should equal 'false'",
		"keyActualValue": "'worker_config[_].public_ip_assigned' is equal 'true'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	worker_config := resource.worker_config[_]

    not common_lib.valid_key(worker_config, "public_ip_assigned")
    common_lib.valid_key(worker_config, "internet_max_bandwidth_out")

	worker_config.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config[_].public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", "_", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'worker_config[_].public_ip_assigned' should equal 'false'",
		"keyActualValue": "'worker_config[_].public_ip_assigned' is equal 'true' or undefined",
	}
}
