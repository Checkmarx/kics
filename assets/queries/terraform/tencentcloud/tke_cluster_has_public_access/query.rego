package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# master_config
CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config

    common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

	masterConfig.public_ip_assigned == true
	masterConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned should be equal to 'false'", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned is equal to 'true'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config[index]

    common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

	masterConfig.public_ip_assigned == true
	masterConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", index, "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned should be equal to 'false'", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.public_ip_assigned is equal 'true'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config

    not common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

    masterConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", "internet_max_bandwidth_out"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out should equal '0' or undefined", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out is not equal '0'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	masterConfig := resource.master_config[index]

	not common_lib.valid_key(masterConfig, "public_ip_assigned")
    common_lib.valid_key(masterConfig, "internet_max_bandwidth_out")

	masterConfig.internet_max_bandwidth_out > 0

	result := {
        "documentId": input.document[i].id,
        "resourceType": "tencentcloud_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "master_config", index, "internet_max_bandwidth_out"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out should equal '0' or null", [name]),
        "keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].master_config.internet_max_bandwidth_out is not equal '0'", [name]),
    }
}

# worker_config
CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config

    common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

	workerConfig.public_ip_assigned == true
	workerConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned should equal 'false'", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned is equal 'true'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config[index]

    common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

	workerConfig.public_ip_assigned == true
	workerConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", index, "public_ip_assigned"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned should equal 'false'", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.public_ip_assigned is equal 'true'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config

    not common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

    workerConfig.internet_max_bandwidth_out > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", "internet_max_bandwidth_out"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out should equal '0' or undefined", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out is defined and not equal to '0'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
	workerConfig := resource.worker_config[index]

	not common_lib.valid_key(workerConfig, "public_ip_assigned")
    common_lib.valid_key(workerConfig, "internet_max_bandwidth_out")

	workerConfig.internet_max_bandwidth_out > 0

	result := {
        "documentId": input.document[i].id,
        "resourceType": "tencentcloud_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name, "worker_config", index, "internet_max_bandwidth_out"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out should be equal to '0' or null", [name]),
        "keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s].worker_config.internet_max_bandwidth_out is defined and not equal to '0'", [name]),
    }
}
