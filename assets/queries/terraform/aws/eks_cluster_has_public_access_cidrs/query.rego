package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_eks_cluster[name]

	resource.vpc_config.endpoint_public_access == true
	"0.0.0.0/0" in resource.vpc_config.public_access_cidrs

	result := {
		"documentId": doc.id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'vpc_config.public_access_cidrs' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'vpc_config.public_access_cidrs' is equal '0.0.0.0/0'",
	}
}

# default value of cidrs is "0.0.0.0/0"
CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_eks_cluster[name]

	resource.vpc_config.endpoint_public_access == true
	not resource.vpc_config.public_access_cidrs

	result := {
		"documentId": doc.id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'vpc_config.public_access_cidrs' should exist",
		"keyActualValue": "'vpc_config.public_access_cidrs' is missing",
	}
}
