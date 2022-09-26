package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_load_balancer_policy[name]
	protocol := resource.policy_attribute.name

	common_lib.weakCipher(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_load_balancer_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_load_balancer_policy[%s].policy_attribute.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s].name' should not be a weak cipher", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s].name' is a weak cipher", [name, protocol]),
	}
}

CxPolicy[result] {
	policy := input.document[i].resource.aws_load_balancer_policy[name]

	some j
	protocol := policy.policy_attribute[j].name
	common_lib.weakCipher(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_load_balancer_policy",
		"resourceName": tf_lib.get_resource_name(policy, name),
		"searchKey": sprintf("aws_load_balancer_policy[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s].name' should not be a weak cipher", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s].name' is a weak cipher", [name, protocol]),
	}
}
