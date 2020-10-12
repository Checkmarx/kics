package Cx

CxPolicy [ result ] {
    required_log_types_set = { "api", "audit", "authenticator", "controllerManager", "scheduler"  }
    logs := input.document[i].resource.aws_eks_cluster[name].enabled_cluster_log_types
    existing_log_types_set := {x | x = logs[_]}
    existing_log_types_set & existing_log_types_set != required_log_types_set

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_eks_cluster[%s].enabled_cluster_log_types", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'enabled_cluster_log_types' has all log types",
                "keyActualValue": 	"'enabled_cluster_log_types' has missing log types"
              })
}
