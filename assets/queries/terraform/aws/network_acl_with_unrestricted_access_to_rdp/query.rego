package Cx

import data.generic.terraform as terra_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_network_acl[name]

	is_array(resource.ingress)
	terra_lib.openPort(resource.ingress[idx], 3389)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_network_acl[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s].ingress[%d] 'RDP' (TCP:3389) is not public", [name, idx]),
		"keyActualValue": sprintf("aws_network_acl[%s].ingress[%d] 'RDP' (TCP:3389) is public", [name, idx]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	net_acl := doc.resource.aws_network_acl[netAclName]
	net_acl_rule := doc.resource.aws_network_acl_rule[netAclRuleName]
	split(net_acl_rule.network_acl_id, ".")[1] == netAclName

	terra_lib.openPort(net_acl_rule, 3389)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_network_acl_rule[%s]", [netAclRuleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s] 'RDP' (TCP:3389) is not public", [netAclRuleName]),
		"keyActualValue": sprintf("aws_network_acl[%s] 'RDP' (TCP:3389) is public", [netAclRuleName]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_network_acl[name]

	not is_array(resource.ingress)
	terra_lib.openPort(resource.ingress, 3389)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_network_acl[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s].ingress 'RDP' (TCP:3389) is not public", [name]),
		"keyActualValue": sprintf("aws_network_acl[%s].ingress 'RDP' (TCP:3389) is public", [name]),
	}
}
