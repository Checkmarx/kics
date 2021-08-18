package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.aws_cloudformation_stack_set_instance[name]
	not common_lib.valid_key(stack, "retain_stack")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudformation_stack_set_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.aws_cloudformation_stack_set_instance[name]
	stack.retain_stack == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is true ", [name]),
		"keyActualValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is false", [name]),
	}
}
