package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

insecure_protocols := ["Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"]

CxPolicy[result] {
	policy := input.document[i].resource.aws_load_balancer_policy[name]

	protocol := policy.policy_attribute.name
	commonLib.inArray(insecure_protocols, protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_load_balancer_policy",
		"resourceName": tf_lib.get_resource_name(policy, name),
		"searchKey": sprintf("aws_load_balancer_policy[%s].policy_attribute.name", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_load_balancer_policy", name, "policy_attribute", "name" ], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' should not be an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
		"remediation": json.marshal({
			"before": sprintf("%s", [protocol]),
			"after": "Protocol-TLSv1.2"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	policy := input.document[i].resource.aws_load_balancer_policy[name]

	some j
	protocol := policy.policy_attribute[j].name
	commonLib.inArray(insecure_protocols, protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_load_balancer_policy",
		"resourceName": tf_lib.get_resource_name(policy, name),
		"searchKey": sprintf("aws_load_balancer_policy[%s].policy_attribute[%d].name", [name,j]),
		"searchLine": commonLib.build_search_line(["resource", "aws_load_balancer_policy", name, "policy_attribute", j, "name" ], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' should not be an insecure protocol", [name, protocol]),
		"keyActualValue": sprintf("'aws_load_balancer_policy[%s].policy_attribute[%s]' is an insecure protocol", [name, protocol]),
		"remediation": json.marshal({
			"before": sprintf("%s", [protocol]),
			"after": "Protocol-TLSv1.2"
		}),
		"remediationType": "replacement",
	}
}
