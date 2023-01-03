package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sagemaker_notebook_instance[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sagemaker_notebook_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sagemaker_notebook_instance[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sagemaker_notebook_instance.kms_key_id should be defined and not null",
		"keyActualValue": "aws_sagemaker_notebook_instance.kms_key_id is undefined or null",
	}
}
