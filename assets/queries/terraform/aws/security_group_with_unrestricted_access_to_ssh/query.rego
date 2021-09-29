package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	terra_lib.openPort(resource.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is not public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is public", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress.cidr_blocks"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", "ingress_cidr_blocks")
	terra_lib.openPort(module.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'SSH' (Port:22) is not public",
		"keyActualValue": "'SSH' (Port:22) is public",
		"searchLine": common_lib.build_search_line(["module", name, "ingress", "cidr_blocks"], []),
	}
}
