package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_ingress_rule" or "aws_security_group_rule"
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource)

	results := check_unknown_port_for_rules(resource,name,types[i2])
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey":  results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

CxPolicy[result] {
	#Case of "aws_security_group"
	resource := input.document[i].resource.aws_security_group[name]

	results := check_unknown_port(resource.ingress,name)
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey":  results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

CxPolicy[result] {
	#Case of "security-group" Module
	module := input.document[i].module[name]
	types := ["ingress_with_cidr_blocks","ingress_with_ipv6_cidr_blocks"]
	ingressKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", types[t])
	common_lib.valid_key(module, ingressKey)

	ingress := module[ingressKey][i2]

	unknownPort(ingress.from_port, ingress.to_port)
	tf_lib.check_cidr(ingress)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%d", [name, ingressKey,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s.%d ports are known",[name, ingressKey,i2]),
		"keyActualValue": sprintf("module[%s].%s.%d ports are unknown and exposed to the entire Internet",[name, ingressKey,i2]),
		"searchLine": common_lib.build_search_line(["module", name, ingressKey, i2], []),
	}
}

check_unknown_port(ingress,name) = results {
	is_array(ingress)

	unknownPort(ingress[j].from_port, ingress[j].to_port)
	tf_lib.check_cidr(ingress[j])

	results := {
		"searchKey" : sprintf("aws_security_group[%s].ingress[%d]", [name,j]),
		"keyExpectedValue" : sprintf("aws_security_group[%s].ingress[%d] ports are known", [name,j]),
		"keyActualValue" : sprintf("aws_security_group[%s].ingress[%d] ports are unknown and exposed to the entire Internet", [name,j]),
		"searchLine" : common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", j], []),
	}
} else = results {

	unknownPort(ingress.from_port, ingress.to_port)
	tf_lib.check_cidr(ingress)

	results := {
		"searchKey" : sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue" : sprintf("aws_security_group[%s].ingress ports are known", [name]),
		"keyActualValue" : sprintf("aws_security_group[%s].ingress ports are unknown and exposed to the entire Internet", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
} else = ""

check_unknown_port_for_rules(rule,name,rule_type) = results {

	unknownPort(rule.from_port, rule.to_port)
	tf_lib.check_cidr(rule)

	results := {
		"searchKey" : sprintf("%s[%s]", [rule_type,name]),
		"keyExpectedValue" : sprintf("%s[%s] ports are known", [rule_type,name]),
		"keyActualValue" : sprintf("%s[%s] ports are unknown and exposed to the entire Internet", [rule_type,name]),
		"searchLine" : common_lib.build_search_line(["resource", rule_type , name], []),
	}
} else = ""

unknownPort(from_port,to_port) {
	port := numbers.range(from_port, to_port)[i]
	not common_lib.valid_key(common_lib.tcpPortsMap, port)
}