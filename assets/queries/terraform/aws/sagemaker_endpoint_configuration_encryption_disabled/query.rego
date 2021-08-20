package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	sagemakerEndpoint := input.document[i].resource.aws_sagemaker_endpoint_configuration[name]

	not common_lib.valid_key(sagemakerEndpoint, "kms_key_arn")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sagemaker_endpoint_configuration[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sagemaker_endpoint_configuration.kms_key_arn is defined and not null",
		"keyActualValue": "aws_sagemaker_endpoint_configuration.kms_key_arn is undefined or null",
	}
}
