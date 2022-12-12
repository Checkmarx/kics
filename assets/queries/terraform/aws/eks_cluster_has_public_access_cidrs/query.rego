package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_eks_cluster[name]

	resource.vpc_config.endpoint_public_access == true
	resource.vpc_config.public_access_cidrs[_] == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'vpc_config.public_access_cidrs' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'vpc_config.public_access_cidrs' is equal '0.0.0.0/0'",
	}
}

#default vaule of cidrs is "0.0.0.0/0"
CxPolicy[result] {
	resource := input.document[i].resource.aws_eks_cluster[name]

	resource.vpc_config.endpoint_public_access == true
	not resource.vpc_config.public_access_cidrs

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_eks_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'vpc_config.public_access_cidrs' should exist",
		"keyActualValue": "'vpc_config.public_access_cidrs' is missing",
	}
}
