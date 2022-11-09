package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	domain := input.document[i].resource.aws_elasticsearch_domain[name]

	not domain.encrypt_at_rest

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(domain, name),
		"searchKey": sprintf("aws_elasticsearch_domain[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encrypt_at_rest' should be set and enabled",
		"keyActualValue": "'encrypt_at_rest' is undefined",
		"remediation": "encrypt_at_rest {\n\t\t enabled = true \n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	domain := input.document[i].resource.aws_elasticsearch_domain[name]
	encrypt_at_rest := domain.encrypt_at_rest

	encrypt_at_rest.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticsearch_domain",
		"resourceName": tf_lib.get_resource_name(domain, name),
		"searchKey": sprintf("aws_elasticsearch_domain[%s].encrypt_at_rest.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticsearch_domain", name, "encrypt_at_rest", "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'encrypt_at_rest.enabled' should be true",
		"keyActualValue": "'encrypt_at_rest.enabled' is false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
