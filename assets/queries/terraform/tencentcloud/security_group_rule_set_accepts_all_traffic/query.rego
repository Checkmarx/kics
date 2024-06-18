package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# ingress ipv4
CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress

	common_lib.valid_key(ingressCheck, "action")
	common_lib.valid_key(ingressCheck, "cidr_block")
	common_lib.valid_key(ingressCheck, "protocol")
    common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.cidr_block == "0.0.0.0/0"
    ingressCheck.protocol == "ALL"
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not be set to accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress is set to accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[index]

	common_lib.valid_key(ingressCheck, "action")
	common_lib.valid_key(ingressCheck, "cidr_block")
	common_lib.valid_key(ingressCheck, "protocol")
    common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.cidr_block == "0.0.0.0/0"
    ingressCheck.protocol == "ALL"
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not be set to accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress is set to accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress", index], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress

	common_lib.valid_key(ingressCheck, "action")
    common_lib.valid_key(ingressCheck, "cidr_block")
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

    ingressCheck.cidr_block == "0.0.0.0/0"
    ingressCheck.action == "ACCEPT"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not be set to accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[index]

	common_lib.valid_key(ingressCheck, "action")
    common_lib.valid_key(ingressCheck, "cidr_block")
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

    ingressCheck.cidr_block == "0.0.0.0/0"
    ingressCheck.action == "ACCEPT"

	result := {
		"documentId": input.document[i].id,
        "resourceType": "tencentcloud_security_group_rule_set",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
        "keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress", index], []),
	}
}

# ingress ipv6
CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress

	common_lib.valid_key(ingressCheck, "action")
	common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
	common_lib.valid_key(ingressCheck, "protocol")
	common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.ipv6_cidr_block == "::/0"
    ingressCheck.protocol == "ALL"
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[index]

	common_lib.valid_key(ingressCheck, "action")
	common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
	common_lib.valid_key(ingressCheck, "protocol")
	common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.ipv6_cidr_block == "::/0"
    ingressCheck.protocol == "ALL"
    ingressCheck.port == "ALL"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not set accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress", index], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress

	common_lib.valid_key(ingressCheck, "action")
    common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.ipv6_cidr_block == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not be set to accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress is set to accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_security_group_rule_set[name]
    ingressCheck := resource.ingress[index]

	common_lib.valid_key(ingressCheck, "action")
    common_lib.valid_key(ingressCheck, "ipv6_cidr_block")
    not common_lib.valid_key(ingressCheck, "protocol")
    not common_lib.valid_key(ingressCheck, "port")

	ingressCheck.action == "ACCEPT"
    ingressCheck.ipv6_cidr_block == "::/0"

    result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_security_group_rule_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_security_group_rule_set[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress should not be set to accept all traffic", [name]),
		"keyActualValue": sprintf("tencentcloud_security_group_rule_set[%s] ingress is set to accept all traffic", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_security_group_rule_set", name, "ingress", index], []),
	}
}
