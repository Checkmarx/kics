package Cx

import data.generic.common as commonLib

insecure_protocols := ["Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"]

CxPolicy[result] {
	policy := input.document[i].resource.aws_load_balancer_policy[name]

	protocol := policy.policy_attribute.name
	commonLib.inArray(insecure_protocols, protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_load_balancer_policy[%s].policy_attribute.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is not an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
	}
}

CxPolicy[result] {
	policy := input.document[i].resource.aws_load_balancer_policy[name]

	some j
	protocol := policy.policy_attribute[j].name
	commonLib.inArray(insecure_protocols, protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_load_balancer_policy[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is not an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
	}
}
