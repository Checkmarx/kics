package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_codebuild_project[name]

	terraLib.uses_aws_managed_key(resource.encryption_key, "alias/aws/s3")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_codebuild_project[%s].encryption_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "CodeBuild Project is not encrypted with AWS managed key",
		"keyActualValue": "CodeBuild Project is encrypted with AWS managed key",
	}
}
