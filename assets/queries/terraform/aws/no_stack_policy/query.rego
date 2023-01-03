package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudformation_stack[name]

	not resource.policy_body
	not resource.policy_url

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudformation_stack",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'policy_body' or Attribute 'policy_url' should be set",
		"keyActualValue": "Both Attribute 'policy_body' and Attribute 'policy_url' are undefined",
	}
}
