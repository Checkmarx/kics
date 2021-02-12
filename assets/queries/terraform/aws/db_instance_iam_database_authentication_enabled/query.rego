package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	object.get(resource,"iam_database_authentication_enabled","undefined") != "undefined"
	not resource.iam_database_authentication_enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_instance.iam_database_authentication_enabled' is true",
		"keyActualValue": "'aws_db_instance.iam_database_authentication_enabled' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	object.get(resource,"iam_database_authentication_enabled","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_db_instance.iam_database_authentication_enabled' is set",
		"keyActualValue": "'aws_db_instance.iam_database_authentication_enabled' is undefined",
	}
}
