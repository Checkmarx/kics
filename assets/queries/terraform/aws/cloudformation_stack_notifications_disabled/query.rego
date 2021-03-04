package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudformation_stack[name]

	not resource.notification_arns

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'notification_arns' is set",
		"keyActualValue": "Attribute 'notification_arns' is undefined",
	}
}
