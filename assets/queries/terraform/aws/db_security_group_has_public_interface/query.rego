package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_security_group[name]

	cidrs := {"0.0.0.0/0", "::/0"}
	cidrValue := cidrs[_]

	resource.ingress.cidr == cidrValue

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_db_security_group[%s].ingress.cidr' is not '0.0.0.0/0' or '::/0'", [name]),
		"keyActualValue": sprintf("'aws_db_security_group[%s].ingress.cidr' is '%s'", [name, resource.ingress.cidr]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_security_group", name, "ingress", "cidr"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_security_group[name]

	cidrs := {"0.0.0.0/0", "::/0"}
	cidrValue := cidrs[_]

	resource.ingress[idx].cidr == cidrValue

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_db_security_group[%s].ingress[%d].cidr' is not '0.0.0.0/0' or '::/0'", [name, idx]),
		"keyActualValue": sprintf("'aws_db_security_group[%s].ingress[%d].cidr' is '%s'", [name, idx, resource.ingress[idx].cidr]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_security_group", name, "ingress", idx, "cidr"], []),
	}
}
