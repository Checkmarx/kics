package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_cloudformation_stack[name]

	not resource.notification_arns

	result := {
		"documentId": doc.id,
		"resourceType": "aws_cloudformation_stack",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'notification_arns' should be set",
		"keyActualValue": "Attribute 'notification_arns' is undefined",
	}
}
