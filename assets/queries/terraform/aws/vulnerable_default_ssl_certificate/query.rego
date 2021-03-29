package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	object.get(resource, "viewer_certificate", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudfront_distribution[%s].viewer_certificate is defined", [name]),
		"keyActualValue": sprintf("aws_cloudfront_distribution[%s].viewer_certificate is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cloudfront_distribution[%s].viewer_certificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'cloudfront_default_certificate' is 'false' or not defined",
		"keyActualValue": "Attribute 'cloudfront_default_certificate' is 'true'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	hasCustomConfig(resource.viewer_certificate)

	attr := {"ssl_support_method", "minimum_protocol_version"}
	object.get(resource.viewer_certificate, attr[a], "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_cloudfront_distribution[%s].viewer_certificate", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attributes 'ssl_support_method' and 'minimum_protocol_version' are defined when one of 'acm_certificate_arn' or 'iam_certificate_id' is declared.",
		"keyActualValue": sprintf("Attribute '%s' is not defined", [attr[a]]),
	}
}

hasCustomConfig(viewer_certificate) {
	object.get(viewer_certificate, "acm_certificate_arn", "undefined") != "undefined"
}

hasCustomConfig(viewer_certificate) {
	object.get(viewer_certificate, "iam_certificate_id", "undefined") != "undefined"
}
