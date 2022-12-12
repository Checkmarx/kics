package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	resource.viewer_certificate.cloudfront_default_certificate == false
	not checkMinProtocolVersion(resource.viewer_certificate.minimum_protocol_version)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version should start with TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version doesn't start with TLSv1.1 or TLSv1.2", [name]),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.viewer_certificate.minimum_protocol_version]),
			"after": "TLSv1.2"
		}),
		"remediationType": "replacement",
	}
}


checkMinProtocolVersion(protocolVersion) {
	startswith(protocolVersion, "TLSv1.1")
} else {
	startswith(protocolVersion, "TLSv1.2")
}
