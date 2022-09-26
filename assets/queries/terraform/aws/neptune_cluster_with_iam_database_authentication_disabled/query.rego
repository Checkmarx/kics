package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_neptune_cluster[name]
	not common_lib.valid_key(password_policy, "iam_database_authentication_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_neptune_cluster",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_neptune_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_neptune_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined",
		"remediation": "iam_database_authentication_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	password_policy := input.document[i].resource.aws_neptune_cluster[name]
	password_policy.iam_database_authentication_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_neptune_cluster",
		"resourceName": tf_lib.get_resource_name(password_policy, name),
		"searchKey": sprintf("aws_neptune_cluster[%s].iam_database_authentication_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_neptune_cluster", name, "iam_database_authentication_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
