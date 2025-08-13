package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	not is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress shouldn't open the remote desktop port (3389)", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens the remote desktop port (3389)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress[i2], 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d] shouldn't open the remote desktop port (3389)", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d] opens the remote desktop port (3389)", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_vpc_security_group_ingress_rule[name]

	tf_lib.portOpenToInternet(resource, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc_security_group_ingress_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_vpc_security_group_ingress_rule[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s] shouldn't open the remote desktop port (3389)", [name]),
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s] opens the remote desktop port (3389)", [name]),
		"searchLine": common_lib.build_search_line(path, ["Properties", "StorageEncrypted"]),
		"searchLine": common_lib.build_search_line(["resource", "aws_vpc_security_group_ingress_rule", name], []),
	}
}