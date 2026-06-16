package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# aws_security_group — single ingress block
CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	ingress_list.is_unique_element

	cidr := ingress_list.value[_].cidr_blocks[_]
	is_wide_cidr(cidr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.cidr_blocks should use a CIDR prefix length greater than /8", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.cidr_blocks '%s' has prefix /%s, granting access to a very large IP range", [name, cidr, split(cidr, "/")[1]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", "cidr_blocks"], []),
	}
}

# aws_security_group — multiple ingress blocks
CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	not ingress_list.is_unique_element

	ingress := ingress_list.value[j]
	cidr := ingress.cidr_blocks[_]
	is_wide_cidr(cidr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks", [name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks should use a CIDR prefix length greater than /8", [name, j]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks '%s' has prefix /%s, granting access to a very large IP range", [name, j, cidr, split(cidr, "/")[1]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", j, "cidr_blocks"], []),
	}
}

# aws_vpc_security_group_ingress_rule
CxPolicy[result] {
	rule := input.document[i].resource.aws_vpc_security_group_ingress_rule[name]
	cidr := rule.cidr_ipv4
	is_wide_cidr(cidr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc_security_group_ingress_rule",
		"resourceName": tf_lib.get_resource_name(rule, name),
		"searchKey": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 should use a CIDR prefix length greater than /8", [name]),
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 '%s' has prefix /%s, granting access to a very large IP range", [name, cidr, split(cidr, "/")[1]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_vpc_security_group_ingress_rule", name, "cidr_ipv4"], []),
	}
}

# aws_security_group_rule (type = ingress)
CxPolicy[result] {
	rule := input.document[i].resource.aws_security_group_rule[name]
	tf_lib.is_security_group_ingress("aws_security_group_rule", rule)
	cidr := rule.cidr_blocks[_]
	is_wide_cidr(cidr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group_rule",
		"resourceName": tf_lib.get_resource_name(rule, name),
		"searchKey": sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group_rule[%s].cidr_blocks should use a CIDR prefix length greater than /8", [name]),
		"keyActualValue": sprintf("aws_security_group_rule[%s].cidr_blocks '%s' has prefix /%s, granting access to a very large IP range", [name, cidr, split(cidr, "/")[1]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group_rule", name, "cidr_blocks"], []),
	}
}

# CIDR prefix length 1–8: covers hundreds of millions to billions of IPs.
# Prefix 0 (0.0.0.0/0) is already caught by unrestricted_security_group_ingress.
# 10.0.0.0/8 is the standard RFC 1918 Class-A private range and is excluded.
is_wide_cidr(cidr) {
	contains(cidr, "/")
	prefix := to_number(split(cidr, "/")[1])
	prefix >= 1
	prefix <= 8
	cidr != "10.0.0.0/8"
}
