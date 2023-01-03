package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_domain_name[name]

	not common_lib.valid_key(resource, "security_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_domain_name",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_domain_name[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_domain_name", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_domain_name[%s].security_policy should be set", [name]),
		"keyActualValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is undefined", [name]),
		"remediation": "security_policy = \"TLS_1_2\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_domain_name[name]

	resource.security_policy != "TLS_1_2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_domain_name",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_domain_name[%s].security_policy", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_domain_name", name, "security_policy"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_domain_name[%s].security_policy should be set to TLS_1_2", [name]),
		"keyActualValue": sprintf("aws_api_gateway_domain_name[%s].security_policy is set to %s", [name, resource.security_policy]),
		"remediation": json.marshal({
			"before": sprintf("%s",[resource.security_policy]),
			"after": "TLS_1_2"
		}),
		"remediationType": "replacement",
	}
}
