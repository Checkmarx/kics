package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_codebuild_project[name]

	tf_lib.uses_aws_managed_key(resource.encryption_key, "alias/aws/s3")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_codebuild_project",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_codebuild_project[%s].encryption_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "CodeBuild Project should not be encrypted with AWS managed key",
		"keyActualValue": "CodeBuild Project is encrypted with AWS managed key",
	}
}
