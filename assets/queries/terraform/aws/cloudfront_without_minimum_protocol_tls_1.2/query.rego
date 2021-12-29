package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	not common_lib.valid_key(resource, "viewer_certificate")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate' is defined and not null", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate == true

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate' is 'false'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate' is 'true'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "viewer_certificate", "cloudfront_default_certificate"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate == false
	protocol_version := resource.viewer_certificate.minimum_protocol_version

	not common_lib.is_recommended_tls(protocol_version)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is TLSv1.2_x", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is %s", [name, protocol_version]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "viewer_certificate", "minimum_protocol_version"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate == false
	not common_lib.valid_key(resource.viewer_certificate, "minimum_protocol_version")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is defined and not null", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "viewer_certificate"], []),
	}
}
