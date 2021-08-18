package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sagemaker_notebook_instance[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sagemaker_notebook_instance[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sagemaker_notebook_instance.kms_key_id is defined and not null",
		"keyActualValue": "aws_sagemaker_notebook_instance.kms_key_id is undefined or null",
	}
}
