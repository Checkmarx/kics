package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

blocks := {"ingress", "egress"}

CxPolicy[result] {
	resource := input.document[i].resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")
	block := blocks[b]
	common_lib.valid_key(resource, block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_default_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_default_security_group[{{%s}}] should not have '%s' defined", [name, block]),
		"keyActualValue": sprintf("aws_default_security_group[{{%s}}] has '%s' defined", [name, block]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")

	block := blocks[b]
	cidrs := {"cidr_blocks", "ipv6_cidr_blocks"}
	acceptAll := {"0.0.0.0/0", "::/0"}

	# ingress or egress
	rules := resource[block][_]

	# ingress.cidr_blocks or ingress.ipv6_cidr_blocks or egress.cidr_blocks or egress.ipv6_cidr_blocks
	cidr := rules[cidrs[c]][_]

	cidr == acceptAll[a]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_default_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s.%s", [name, block, cidrs[c]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be undefined", [block]),
		"keyActualValue": sprintf("'%s' accepts all traffic", [block]),
	}
}
