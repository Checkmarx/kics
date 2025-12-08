package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_ingress_rule" or "aws_security_group_rule"
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource)
	tf_lib.portOpenToInternet(resource, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s] shouldn't open the remote desktop port (3389)", [types[i2],name]),
		"keyActualValue": sprintf("%s[%s] opens the remote desktop port (3389)", [types[i2],name]),
		"searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
	}
}

CxPolicy[result] {
	#Case of "aws_security_group"
	resource := input.document[i].resource.aws_security_group[name]

	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	results := desktop_port_is_open(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
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

	tf_lib.portOpenToInternet(ingress, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%d", [name, ingressKey,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s.%d shouldn't open the remote desktop port (3389)",[name, ingressKey,i2]),
		"keyActualValue": sprintf("module[%s].%s.%d opens the remote desktop port (3389)",[name, ingressKey,i2]),
		"searchLine": common_lib.build_search_line(["module", name, ingressKey, i2], []),
	}
}

desktop_port_is_open(ingress,is_unique_element,name,i2) = results {
	is_unique_element
	tf_lib.portOpenToInternet(ingress, 3389)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress shouldn't open the remote desktop port (3389)", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens the remote desktop port (3389)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
} else = results {
	not is_unique_element
	tf_lib.portOpenToInternet(ingress, 3389)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] shouldn't open the remote desktop port (3389)", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] opens the remote desktop port (3389)", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
}
