package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	services := {"aws_api_gateway_domain_name", "aws_iam_server_certificate", "aws_acm_certificate"}

	resourceType == services[_]

	resource[name].certificate_body.rsa_key_bytes < 256

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].certificate_body", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].certificate_body uses a RSA key with a length equal to or higher than 256 bytes", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].certificate_body does not use a RSA key with a length equal to or higher than 256 bytes", [resourceType, name]),
	}
}
