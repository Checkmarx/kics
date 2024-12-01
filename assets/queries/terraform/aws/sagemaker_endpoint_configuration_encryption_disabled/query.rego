package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	sagemakerEndpoint := document.resource.aws_sagemaker_endpoint_configuration[name]

	not common_lib.valid_key(sagemakerEndpoint, "kms_key_arn")

	result := {
		"documentId": document.id,
		"resourceType": "aws_sagemaker_endpoint_configuration",
		"resourceName": tf_lib.get_resource_name(sagemakerEndpoint, name),
		"searchKey": sprintf("aws_sagemaker_endpoint_configuration[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_sagemaker_endpoint_configuration[%s] should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_sagemaker_endpoint_configuration[%s] is undefined or null", [name]),
	}
}
