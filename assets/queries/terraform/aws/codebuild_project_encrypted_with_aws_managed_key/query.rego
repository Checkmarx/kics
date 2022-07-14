package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_codebuild_project[name]

	tf_lib.uses_aws_managed_key(resource.encryption_key, "alias/aws/s3")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_codebuild_project",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_codebuild_project[%s].encryption_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "CodeBuild Project should not be encrypted with AWS managed key",
		"keyActualValue": "CodeBuild Project is encrypted with AWS managed key",
	}
}
