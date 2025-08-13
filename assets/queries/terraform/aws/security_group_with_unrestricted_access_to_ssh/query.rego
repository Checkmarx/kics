package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#resource with single ingress
	resource := input.document[i].resource.aws_security_group[name]
	
	not is_array(resource.ingress)
	tf_lib.portOpenToInternet(resource.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) should not be public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is public", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress"], []),
	}
}

CxPolicy[result] {
	#module with single ingress
	module := input.document[i].module[name]
	common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_cidr_blocks")
	
	not is_array(module.ingress)
	tf_lib.portOpenToInternet(module.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'SSH' (Port:22) should not be public",
		"keyActualValue": "'SSH' (Port:22) is public",
		"searchLine": common_lib.build_search_line(["module", name, "ingress"], []),
	}
}

CxPolicy[result] {
	#resource with multiple ingresses
	document := input.document[i].resource.aws_security_group[name]

	is_array(document.ingress)
	resource := document.ingress[i2]

	tf_lib.portOpenToInternet(resource, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress[%d]", [name,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) should not be public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is public", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2], []),
	}
}



CxPolicy[result] {
	#module with multiple ingresses
	module := input.document[i].module[name]
	common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_cidr_blocks")

	is_array(module.ingress)
	resource := module.ingress[i2]

	tf_lib.portOpenToInternet(resource, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ingress[%d]", [name,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'SSH' (Port:22) should not be public",
		"keyActualValue": "'SSH' (Port:22) is public",
		"searchLine": common_lib.build_search_line(["module", name, "ingress", i2], []),
	}
}
