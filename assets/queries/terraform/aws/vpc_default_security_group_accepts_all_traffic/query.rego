package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

blocks := {"ingress", "egress"}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")
	block := blocks[b]
	common_lib.valid_key(resource, block)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_default_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_default_security_group[{{%s}}] should not have '%s' defined", [name, block]),
		"keyActualValue": sprintf("aws_default_security_group[{{%s}}] has '%s' defined", [name, block]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")

	block := blocks[b]
	cidrs := {"cidr_blocks", "ipv6_cidr_blocks"}
	acceptAll := {"0.0.0.0/0", "::/0"}

	# ingress or egress
	some rules in resource[block]

	# ingress.cidr_blocks or ingress.ipv6_cidr_blocks or egress.cidr_blocks or egress.ipv6_cidr_blocks
	some cidr in rules[cidrs[c]]

	cidr == acceptAll[a]

	result := {
		"documentId": doc.id,
		"resourceType": "aws_default_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s.%s", [name, block, cidrs[c]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be undefined", [block]),
		"keyActualValue": sprintf("'%s' accepts all traffic", [block]),
	}
}
