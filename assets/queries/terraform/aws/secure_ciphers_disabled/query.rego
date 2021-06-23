package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	resource.viewer_certificate.cloudfront_default_certificate == false
	not checkMinProtocolVersion(resource.viewer_certificate.minimum_protocol_version)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version starts with TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version isn't start with TLSv1.1 or TLSv1.2", [name]),
	}
}


checkMinProtocolVersion(protocolVersion) {
	startswith(protocolVersion, "TLSv1.1")
} else {
	startswith(protocolVersion, "TLSv1.2")
}
