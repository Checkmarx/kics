package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	tf_lib.portOpenToInternet(resource.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) should not be public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is public", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress.cidr_blocks"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_cidr_blocks")
	tf_lib.portOpenToInternet(module.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'SSH' (Port:22) should not be public",
		"keyActualValue": "'SSH' (Port:22) is public",
		"searchLine": common_lib.build_search_line(["module", name, "ingress", "cidr_blocks"], []),
	}
}
