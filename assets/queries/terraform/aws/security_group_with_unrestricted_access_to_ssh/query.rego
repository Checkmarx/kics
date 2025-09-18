package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_ingress_rule" or "aws_security_group_rule"
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource) # o resource for do tipo "aws_security_group_rule com resource.type == "ingress" ou 
														 # o resource for do tipo "aws_vpc_security_group_ingress_rule"
	
	tf_lib.portOpenToInternet(resource, 22) # verifica se a porta está aberta para a Internet (cidr 0.0.0.0) e o protocolo é tcp e se contem a porta 22

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),	
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s] 'SSH' (Port:22) should not be open", [types[i2],name]),
		"keyActualValue": sprintf("%s[%s] 'SSH' (Port:22) is open", [types[i2],name]),
		"searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
	}
}

CxPolicy[result] {
	#Case of "aws_security_group"
	resource := input.document[i].resource.aws_security_group[name]
	
	ingress_list := tf_lib.get_ingress_list(resource.ingress) # retorna o ingress no "value" e se é um elemento único ou se tem vários(is_unique_element)
	results := ssh_port_is_open(ingress_list.value[i2],ingress_list.is_unique_element,name,i2) # verifica se 
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
	types := ["ingress_with_cidr_blocks","ingress_with_ipv6_cidr_blocks"]
	ingressKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", types[t])
	common_lib.valid_key(module, ingressKey)

	ingress := module[ingressKey][i2]

	tf_lib.portOpenToInternet(ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%d", [name, ingressKey,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s.%d 'SSH' (Port:22) should not be open",[name, ingressKey,i2]),
		"keyActualValue": sprintf("module[%s].%s.%d 'SSH' (Port:22) is open",[name, ingressKey,i2]),
		"searchLine": common_lib.build_search_line(["module", name, ingressKey, i2], []),
	}
}

ssh_port_is_open(ingress,is_unique_element,name,i2) = results {
	is_unique_element # se o ingress block só tiver 1 elemento (só houver 1 ingress)
	tf_lib.portOpenToInternet(ingress, 22) # verificar se tem a porta aberta para a internet 
										   # protocolo for tcp, mais as verificações feitas em contains port
										   # mais, se o cidr-block tiver 0.0.0.0/0 ou o equivalente para IPv6

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress 'SSH' (Port:22) should not be open", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress 'SSH' (Port:22) is open", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
} else = results {
	not is_unique_element # mais do que 1 ingress
	tf_lib.portOpenToInternet(ingress, 22) # verifica se a porta está aberta a Internet

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] 'SSH' (Port:22) should not be open", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] 'SSH' (Port:22) is open", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
} else = ""