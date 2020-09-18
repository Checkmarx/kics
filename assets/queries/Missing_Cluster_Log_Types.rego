package Cx

SupportedResources = "$.resource.aws_eks_cluster"

CxPolicy [ result ] {
    required_log_types_set = { "api", "audit", "authenticator", "controllerManager", "scheduler"  }
    logs := input.document[i].resource.aws_eks_cluster[name].enabled_cluster_log_types
    existing_log_types_set := {x | x = logs[_]}
    existing_log_types_set & existing_log_types_set != required_log_types_set

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_eks_cluster[%s].enabled_cluster_log_types", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "api, audit, authenticator, controllerManager, scheduler",
                "keyActualValue": 	null
              })
}
