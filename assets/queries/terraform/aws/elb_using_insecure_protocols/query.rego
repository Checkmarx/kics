package Cx

CxPolicy[result] {
	some name
	protocol := input.document[i].resource.aws_load_balancer_policy[name].policy_attribute.name
	check_vulnerability(protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_load_balancer_policy[%s].policy_attribute.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is not an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
	}
}

CxPolicy[result] {
	some name
	protocol := input.document[i].resource.aws_load_balancer_policy[name].policy_attribute[_].name
	check_vulnerability(protocol)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_load_balancer_policy[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is not an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
	}
}

check_vulnerability(val) {
	insecure_protocols = {"Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"}
	val == insecure_protocols[_]
}
