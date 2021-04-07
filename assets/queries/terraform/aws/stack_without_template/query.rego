package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudformation_stack[name]

	not resource.template_body
	not resource.template_url

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'template_body' or Attribute 'template_url' is set",
		"keyActualValue": "Both Attribute 'template_body' and Attribute 'template_url' are undefined",
	}
}
