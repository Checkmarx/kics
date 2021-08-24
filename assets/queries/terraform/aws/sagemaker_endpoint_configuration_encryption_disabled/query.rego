package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	sagemakerEndpoint := input.document[i].resource.aws_sagemaker_endpoint_configuration[name]

	not common_lib.valid_key(sagemakerEndpoint, "kms_key_arn")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sagemaker_endpoint_configuration[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_sagemaker_endpoint_configuration[%s] is defined and not null", [name]),
		"keyActualValue": sprintf("aws_sagemaker_endpoint_configuration[%s] is undefined or null", [name]),
	}
}
