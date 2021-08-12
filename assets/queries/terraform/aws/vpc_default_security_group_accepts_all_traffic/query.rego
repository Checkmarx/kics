package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")

	common_lib.valid_key(resource, "ingress")
	common_lib.valid_key(resource, "egress")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_default_security_group[{{%s}}]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_default_security_group[{{%s}}] does not have 'ingress' or 'egress' defined", [name]),
		"keyActualValue": sprintf("aws_default_security_group[{{%s}}] has 'ingress' and 'egress' defined", [name]),
	}
}
