package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	nasSecurityGroupRule := input.document[i].resource.nifcloud_nas_security_group[name]
	cidr := split(getRules(nasSecurityGroupRule.rule)[_].cidr_ip, "/")
	to_number(cidr[1]) < 1

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_nas_security_group",
		"resourceName": tf_lib.get_resource_name(nasSecurityGroupRule, name),
		"searchKey": sprintf("nifcloud_nas_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_nas_security_group[%s]' set a more restrictive cidr range", [name]),
		"keyActualValue": sprintf("'nifcloud_nas_security_group[%s]' allows traffic from /0", [name]),
	}
}

getRules (rule) = output {
	not is_array(rule) 
	output := [rule]
} else = output {
	output := rule
}