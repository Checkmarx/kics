package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	required_log_types_set = {"api", "audit", "authenticator", "controllerManager", "scheduler"}
	logs := input.document[i].resource.aws_eks_cluster[name].enabled_cluster_log_types
	existing_log_types_set := {x | x = logs[_]}
	existing_log_types_set & existing_log_types_set != required_log_types_set

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_eks_cluster[name], name),
		"searchKey": sprintf("aws_eks_cluster[%s].enabled_cluster_log_types", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enabled_cluster_log_types' has all log types",
		"keyActualValue": "'enabled_cluster_log_types' has missing log types",
	}
}
