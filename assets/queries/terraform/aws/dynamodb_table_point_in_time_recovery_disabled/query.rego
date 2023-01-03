package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_dynamodb_table"
	res := resource[m]
	res.point_in_time_recovery.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dynamodb_table",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}].point_in_time_recovery.enabled", [m]),
		"searchLine": common_lib.build_search_line(["resource", "aws_dynamodb_table", name, "point_in_time_recovery","enabled"], []),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "aws_dynamodb_table.point_in_time_recovery.enabled should be set to true",
		"keyActualValue": "aws_dynamodb_table.point_in_time_recovery.enabled is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_dynamodb_table"
	res := resource[m]
	not common_lib.valid_key(res, "point_in_time_recovery")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_dynamodb_table",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_dynamodb_table[{{%s}}]", [m]),
		"searchLine": common_lib.build_search_line(["resource", "aws_dynamodb_table", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_dynamodb_table.point_in_time_recovery.enabled should be enabled",
		"keyActualValue": "aws_dynamodb_table.point_in_time_recovery is missing",
		"remediation": "point_in_time_recovery {\n\t\t enabled = true \n\t}",
		"remediationType": "addition",
	}
}
