package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.iam_database_authentication_enabled == false

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
	not common_lib.valid_key(resource, "iam_database_authentication_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_db_instance.iam_database_authentication_enabled' is defined and not null",
		"keyActualValue": "'aws_db_instance.iam_database_authentication_enabled' is undefined or null",
	}
}
