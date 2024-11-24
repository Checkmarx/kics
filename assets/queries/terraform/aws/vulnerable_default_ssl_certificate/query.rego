package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_cloudfront_distribution[name]

	not common_lib.valid_key(resource, "viewer_certificate")

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudfront_distribution[%s].viewer_certificate should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudfront_distribution[%s].viewer_certificate is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s].viewer_certificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'cloudfront_default_certificate' should be 'false' or not defined",
		"keyActualValue": "Attribute 'cloudfront_default_certificate' is 'true'",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_cloudfront_distribution[name]

	hasCustomConfig(resource.viewer_certificate)

	attr := {"ssl_support_method", "minimum_protocol_version"}
	attributes := attr[a]
	not common_lib.valid_key(resource.viewer_certificate, attributes)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s].viewer_certificate", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attributes 'ssl_support_method' and 'minimum_protocol_version' should be defined when one of 'acm_certificate_arn' or 'iam_certificate_id' is declared.",
		"keyActualValue": sprintf("Attribute '%s' is not defined", [attributes]),
	}
}

hasCustomConfig(viewer_certificate) {
	common_lib.valid_key(viewer_certificate, "acm_certificate_arn")
}

hasCustomConfig(viewer_certificate) {
	common_lib.valid_key(viewer_certificate, "iam_certificate_id")
}
