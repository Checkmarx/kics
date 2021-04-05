package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudformation_stack[name]

	not resource.policy_body
	not resource.policy_url

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'policy_body' or Attribute 'policy_url' is set",
		"keyActualValue": "Both Attribute 'policy_body' and Attribute 'policy_url' are undefined",
	}
}
