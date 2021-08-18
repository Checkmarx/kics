package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	required_log_types_set = {"api", "audit", "authenticator", "controllerManager", "scheduler"}
	cluster := input.document[i].resource.aws_eks_cluster[name]
	not common_lib.valid_key(cluster, "enabled_cluster_log_types")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_eks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cluster_log_types' is defined and not null",
		"keyActualValue": "'enabled_cluster_log_types' is undefined or null",
	}
}
