package Cx

CxPolicy[result] {
	required_log_types_set = {"api", "audit", "authenticator", "controllerManager", "scheduler"}
	cluster := input.document[i].resource.aws_eks_cluster[name]
	object.get(cluster, "enabled_cluster_log_types", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_eks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cluster_log_types' is defined",
		"keyActualValue": "'enabled_cluster_log_types' is not defined",
	}
}
