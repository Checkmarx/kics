package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	using_unrecommended_version(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("GKE should not be using outated versions on min_master_version or node_version %s",[common_lib.get_version("gke")]),
		"keyActualValue": "GKE is using outated versions on min_master_version or node_version",
	}
}

using_unrecommended_version(resource){
	lower(resource.min_master_version) != "latest"
	latest_version := common_lib.get_version("gke")
	not startswith(resource.min_master_version, latest_version)
} else {
	lower(resource.node_version) != "latest"
	latest_version := common_lib.get_version("gke")
	not startswith(resource.node_version, latest_version)
}

