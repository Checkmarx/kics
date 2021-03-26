package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	object.get(resource, "viewer_certificate", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate' is defined", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate' is undefined", [name]),
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
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.viewer_certificate.cloudfront_default_certificate == false
	protocol_version := resource.viewer_certificate.minimum_protocol_version

	not commonLib.inArray(["TLSv1.2_2018", "TLSv1.2_2019"], protocol_version)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is TLSv1.2_x", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is %s", [name, protocol_version]),
	}
}
