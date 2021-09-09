package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_eks_cluster[name]

	not common_lib.valid_key(cluster, "encryption_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_eks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encryption_config' is defined and not null",
		"keyActualValue": "'encryption_config' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_eks_cluster", name], []),
	}
}
