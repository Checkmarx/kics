package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_domain_name[name]

	not common_lib.valid_key(resource, "security_policy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_domain_name[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is set", [name]),
		"keyActualValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_domain_name[name]

	resource.security_policy != "TLS_1_2"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_domain_name[%s].security_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is set to TLS_1_2", [name]),
		"keyActualValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is set to %s", [name, resource.security_policy]),
	}
}
