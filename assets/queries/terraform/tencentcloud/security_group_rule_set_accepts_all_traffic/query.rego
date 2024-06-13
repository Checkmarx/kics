package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[_]

	common_lib.valid_key(ingressCheck, "action")
	ingressCheck.action == "ACCEPT"
	common_lib.valid_key(ingressCheck, "cidr_block")
    ingressCheck.cidr_block == "0.0.0.0/0"
    common_lib.valid_key(ingressCheck, "protocol")
    ingressCheck.protocol == "ALL"
    common_lib.valid_key(ingressCheck, "port")
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress[%d]", [name, _]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": resource.ingress[_].__line__,
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[_]

	common_lib.valid_key(ingressCheck, "action")
	ingressCheck.action == "ACCEPT"
	common_lib.valid_key(ingressCheck, "cidr_block")
    ingressCheck.cidr_block == "0.0.0.0/0"
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress[%d]", [name, _]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": resource.ingress[_].__line__,
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[_]

	common_lib.valid_key(ingressCheck, "action")
	ingressCheck.action == "ACCEPT"
	common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
    ingressCheck.ipv6_cidr_block == "::/0"
    common_lib.valid_key(ingressCheck, "protocol")
    ingressCheck.protocol == "ALL"
    common_lib.valid_key(ingressCheck, "port")
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress[%d]", [name, _]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": resource.ingress[_].__line__,
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[_]

	common_lib.valid_key(ingressCheck, "action")
	ingressCheck.action == "ACCEPT"
	common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
    ingressCheck.ipv6_cidr_block == "::/0"
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress[%d]", [name, _]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": resource.ingress[_].__line__,
	}
}
