package Cx

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_neptune_cluster[name]
	object.get(password_policy, "iam_database_authentication_enabled", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_neptune_cluster[name]
	password_policy.iam_database_authentication_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
	}
}
