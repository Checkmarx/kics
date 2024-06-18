package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_kubernetes_cluster[name]
    not any_kubernetes_encryption_protection(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("tencentcloud_kubernetes_cluster[%s] should have 'tencentcloud_kubernetes_encryption_protection' enabled", [name]),
		"keyActualValue": sprintf("tencentcloud_kubernetes_cluster[%s] does not have 'tencentcloud_kubernetes_encryption_protection' enabled or is undefined", [name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_kubernetes_cluster", name], []),
	}
}

any_kubernetes_encryption_protection(resource_name) {
    encryption := input.document[_].resource.tencentcloud_kubernetes_encryption_protection[_]
    split_name := split(encryption.cluster_id, ".")[1]
    split_name == resource_name
}
