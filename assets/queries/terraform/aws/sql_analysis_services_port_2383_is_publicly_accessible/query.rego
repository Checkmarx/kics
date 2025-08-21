package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib


CxPolicy[result] {
	#Case of aws_vpc_security_group_ingress_rule / aws_security_group_rule
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	resource := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],resource)
	tf_lib.portOpenToInternet(resource, 2383)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),	
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s] shouldn't open SQL Analysis Services Port 2383", [types[i2],name]),
		"keyActualValue": sprintf("%s[%s] opens SQL Analysis Services Port 2383", [types[i2],name]),
		"searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
	}
}

CxPolicy[result] {
	#Case of Single Ingress or Ingress Array
	resource := input.document[i].resource.aws_security_group[name]

	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	results := port_is_open_to_internet(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)
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

port_is_open_to_internet(ingress,is_unique_element,name,i2) = results {
	is_unique_element
	tf_lib.portOpenToInternet(ingress, 2383)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress shouldn't open SQL Analysis Services Port 2383", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens SQL Analysis Services Port 2383", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
} else = results {
	not is_unique_element
	tf_lib.portOpenToInternet(ingress, 2383)

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] shouldn't open SQL Analysis Services Port 2383", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] opens SQL Analysis Services Port 2383", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),

	}
} else = ""
