package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_login_profile[name]

	resource.password_reset_required == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_user_login_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_user_login_profile[%s].password_reset_required", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'password_reset_required' should be true",
		"keyActualValue": "Attribute 'password_reset_required' is false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_login_profile[name]

	resource.password_length < 14

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_user_login_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_user_login_profile[%s].password_length", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'password_length' should be 14 or greater",
		"keyActualValue": "Attribute 'password_length' is smaller than 14",
		"remediation": json.marshal({
			"before": sprintf("%d", [resource.password_length]),
			"after": "15"
		}),
		"remediationType": "replacement",
	}
}
