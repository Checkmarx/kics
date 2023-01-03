package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	not common_lib.valid_key(resource, "enabled")

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled should be set to 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is not defined", [name]),
		"remediation": "enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.enabled == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled should be set to 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is configured as 'false'", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	not common_lib.valid_key(resource, "origin")

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].origin should be defined", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].origin is not defined", [name]),
	}
}
