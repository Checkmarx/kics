package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	securityGroupRule := input.document[i].resource.nifcloud_security_group_rule[name]
    not common_lib.valid_key(securityGroupRule, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_security_group_rule",
		"resourceName": tf_lib.get_resource_name(securityGroupRule, name),
		"searchKey": sprintf("nifcloud_security_group_rule[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_security_group_rule[%s]' should include a description for auditing purposes", [name]),
		"keyActualValue": sprintf("'nifcloud_security_group_rule[%s]' does not have a description", [name]),
	}
}
