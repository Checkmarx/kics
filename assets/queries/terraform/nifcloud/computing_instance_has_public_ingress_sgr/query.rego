package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	securityGroupRule := input.document[i].resource.nifcloud_security_group_rule[name]
	cidr := split(securityGroupRule.cidr_ip, "/")
	to_number(cidr[1]) < 1

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(securityGroupRule, name),
		"searchKey": sprintf("nifcloud_security_group_rule[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_security_group_rule[%s]' set a more restrictive cidr range", [name]),
		"keyActualValue": sprintf("'nifcloud_security_group_rule[%s]' allows traffic from /0", [name]),
	}
}
