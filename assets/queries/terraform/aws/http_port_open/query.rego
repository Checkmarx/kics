package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	#Case of single Ingress
	resource := input.document[i].resource.aws_security_group[name]

	not is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress, 80)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group.ingress shouldn't open the HTTP port (80)",
		"keyActualValue": "aws_security_group.ingress opens the HTTP port (80)",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name], []),
	}
}

CxPolicy[result] {
	#Case of Ingress Array
	resource := input.document[i].resource.aws_security_group[name]

	is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress[i2], 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] shouldn't open the HTTP port (80)", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] opens the HTTP port (80)", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name], []),
	}
}

CxPolicy[result] {
	#Case of aws_vpc_security_group_ingress_rule / aws_security_group_rule
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


