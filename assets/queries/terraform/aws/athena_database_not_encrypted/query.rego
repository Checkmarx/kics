package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_athena_database[name]
	not common_lib.valid_key(resource, "encryption_configuration")

	result := {
		"documentId": document.id,
		"resourceType": "aws_athena_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_athena_database[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration should be defined", [name]),
		"keyActualValue": sprintf("aws_athena_database[{{%s}}] encryption_configuration is missing", [name]),
	}
}
