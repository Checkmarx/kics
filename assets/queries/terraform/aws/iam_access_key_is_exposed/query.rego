package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	access_key := input.document[i].resource.aws_iam_access_key[name]

	lower(object.get(access_key, "status", "Active")) == "active"

	access_key.user == "root"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_access_key",
		"resourceName": tf_lib.get_resource_name(access_key, name),
		"searchKey": sprintf("aws_iam_access_key[%s].user", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_iam_access_key[%s].user' should not be 'root' for an active access key", [name]),
		"keyActualValue": sprintf("'aws_iam_access_key[%s].user' is 'root' for an active access key", [name]),
	}
}
