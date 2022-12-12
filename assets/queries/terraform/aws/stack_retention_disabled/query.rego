package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.aws_cloudformation_stack_set_instance[name]
	not common_lib.valid_key(stack, "retain_stack")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudformation_stack_set_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudformation_stack_set_instance[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudformation_stack_set_instance", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is undefined or null", [name]),
		"remediation": "retain_stack = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.aws_cloudformation_stack_set_instance[name]
	stack.retain_stack == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudformation_stack_set_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudformation_stack_set_instance", name, "retain_stack"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack should be true ", [name]),
		"keyActualValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
