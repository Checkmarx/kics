package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#Case of aws_vpc_security_group_ingress_rule or aws_security_group_rule
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]
	tf_lib.is_security_group_ingress(types[i2],resource)

	tf_lib.portOpenToInternet(resource, 22)

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
	#aws_security_group with Single Ingress or Ingress Array
	resource := input.document[i].resource.aws_security_group[name]
	
	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	results := ssh_port_is_open(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)
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
	#module with Single Ingress or Ingress Array
	module := input.document[i].module[name]
	common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_cidr_blocks")

	ingress_list := tf_lib.get_ingress_list(module.ingress)
	results := module_ssh_port_is_open(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

module_ssh_port_is_open(ingress,is_unique_element,name,i2) = results {
	is_unique_element
	tf_lib.portOpenToInternet(ingress, 22)

	results := {
		"searchKey": sprintf("module[%s].ingress", [name]),
		"keyExpectedValue": sprintf("module[%s].ingress 'SSH' (Port:22) should not be open",[name]),
		"keyActualValue": sprintf("module[%s].ingress 'SSH' (Port:22) is open",[name]),
		"searchLine": common_lib.build_search_line(["module", name, "ingress"], []),
	}

} else = results {
	not is_unique_element
	tf_lib.portOpenToInternet(ingress, 22)

	results := {
		"searchKey": sprintf("module[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue": sprintf("module[%s].ingress[%d] 'SSH' (Port:22) should not be open",[name,i2]),
		"keyActualValue": sprintf("module[%s].ingress[%d] 'SSH' (Port:22) is open",[name,i2]),
		"searchLine": common_lib.build_search_line(["module", name, "ingress", i2], []),
	}
}

ssh_port_is_open(ingress,is_unique_element,name,i2) = results {
	is_unique_element
	tf_lib.portOpenToInternet(ingress, 22)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress 'SSH' (Port:22) should not be open", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress 'SSH' (Port:22) is open", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}

} else = results {
	not is_unique_element
	tf_lib.portOpenToInternet(ingress, 22)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] 'SSH' (Port:22) should not be open", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] 'SSH' (Port:22) is open", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
}


