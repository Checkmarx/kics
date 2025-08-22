package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_ingress_rule" or "aws_security_group_rule"
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource)
	tf_lib.portOpenToInternet(resource, 80)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),	
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s] should not open the HTTP port (80)", [types[i2],name]),
		"keyActualValue": sprintf("%s[%s] opens the HTTP port (80)", [types[i2],name]),
		"searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
	}
}

CxPolicy[result] {
	#Case of "aws_security_group"
	resource := input.document[i].resource.aws_security_group[name]

	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	results := http_is_open(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)
	results != ""

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
	ingressKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_with_cidr_blocks")
	common_lib.valid_key(module, ingressKey)

	ingress := module[ingressKey][i2]

	tf_lib.portOpenToInternet(ingress, 80)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%d", [name, ingressKey,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s.%d should not open the HTTP port (80)",[name, ingressKey,i2]),
		"keyActualValue": sprintf("module[%s].%s.%d opens the HTTP port (80)",[name, ingressKey,i2]),
		"searchLine": common_lib.build_search_line(["module", name, ingressKey, i2], []),
	}
}

http_is_open(ingress,is_unique_element,name,i2) = results {
	is_unique_element
	tf_lib.portOpenToInternet(ingress, 80)

	results := {
		"searchKey" : sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue" : sprintf("aws_security_group[%s].ingress should not open the HTTP port (80)",[name]),
		"keyActualValue" : sprintf("aws_security_group[%s].ingress opens the HTTP port (80)",[name]),
		"searchLine" : common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}

} else = results {
	not is_unique_element
	tf_lib.portOpenToInternet(ingress, 80)

	results := {
		"searchKey" : sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue" : sprintf("aws_security_group[%s].ingress[%d] should not open the HTTP port (80)", [name,i2]),
		"keyActualValue" : sprintf("aws_security_group[%s].ingress[%d] opens the HTTP port (80)", [name,i2]),
		"searchLine" : common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
} else = ""