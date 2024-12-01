package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_ecs_service[name]
	contains(lower(resource.iam_role), "admin")

	result := {
		"documentId": document.id,
		"resourceType": "aws_ecs_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_service[%s].iam_role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_service[%s].iam_role' should not equal to 'admin'", [name]),
		"keyActualValue": sprintf("'aws_ecs_service[%s].iam_role' is equal to 'admin'", [name]),
	}
}
