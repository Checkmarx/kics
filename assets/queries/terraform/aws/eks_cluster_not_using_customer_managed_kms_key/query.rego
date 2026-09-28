package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_eks_cluster[name]

	not common_lib.valid_key(cluster, "encryption_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("aws_eks_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encryption_config' should be defined with a customer managed KMS key in 'provider.key_arn'",
		"keyActualValue": "'encryption_config' is undefined or null, so the default AWS owned KMS key is used",
		"searchLine": common_lib.build_search_line(["resource", "aws_eks_cluster", name], []),
	}
}
