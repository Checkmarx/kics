package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_network_acl[name]

	is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress[idx], 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_network_acl",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_network_acl[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s].ingress[%d] 'RDP' (TCP:3389) should not be public", [name, idx]),
		"keyActualValue": sprintf("aws_network_acl[%s].ingress[%d] 'RDP' (TCP:3389) is public", [name, idx]),
		"searchLine": common_lib.build_search_line(["resource", "aws_network_acl", name, "ingress", idx], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	net_acl := doc.resource.aws_network_acl[netAclName]
	net_acl_rule := doc.resource.aws_network_acl_rule[netAclRuleName]
	split(net_acl_rule.network_acl_id, ".")[1] == netAclName

	tf_lib.portOpenToInternet(net_acl_rule, 3389)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_network_acl_rule",
		"resourceName": netAclRuleName,
		"searchKey": sprintf("aws_network_acl_rule[%s]", [netAclRuleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s] 'RDP' (TCP:3389) should not be public", [netAclRuleName]),
		"keyActualValue": sprintf("aws_network_acl[%s] 'RDP' (TCP:3389) is public", [netAclRuleName]),
		"searchLine": common_lib.build_search_line(["resource", "aws_network_acl_rule", netAclRuleName], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_network_acl[name]

	not is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress, 3389)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_network_acl",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_network_acl[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s].ingress 'RDP' (TCP:3389) should not be public", [name]),
		"keyActualValue": sprintf("aws_network_acl[%s].ingress 'RDP' (TCP:3389) is public", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_network_acl", name, "ingress"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_default_vpc", "default_network_acl_ingress")
	common_lib.valid_key(module, keyToCheck)
	rule := module[keyToCheck][idx]

	tf_lib.portOpenToInternet(rule, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s[%d] 'RDP' (TCP:3389) should not be public", [name, keyToCheck, idx]),
		"keyActualValue": sprintf("module[%s].%s[%d] 'RDP' (TCP:3389) is public", [name, keyToCheck, idx]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, idx], []),
	}
}
