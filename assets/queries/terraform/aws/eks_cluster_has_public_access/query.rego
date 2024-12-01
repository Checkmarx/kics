package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_eks_cluster[name]
	resource.vpc_config.endpoint_public_access == true

	result := {
		"documentId": document.id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_eks_cluster[%s].vpc_config.endpoint_public_access", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_eks_cluster", name, "vpc_config", "endpoint_public_access"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'vpc_config.endpoint_public_access' should equal 'false'",
		"keyActualValue": "'vpc_config.endpoint_public_access' is equal 'true'",
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
