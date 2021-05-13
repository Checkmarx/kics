package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_sagemaker_notebook_instance[name]
	object.get(resource, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sagemaker_notebook_instance[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sagemaker_notebook_instance.kms_key_id is defined",
		"keyActualValue": "aws_sagemaker_notebook_instance.kms_key_id is missing",
	}
}
