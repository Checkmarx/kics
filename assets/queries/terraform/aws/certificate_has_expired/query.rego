package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	services := {"aws_api_gateway_domain_name", "aws_iam_server_certificate", "aws_acm_certificate"}
	resourceType == services[_]

	expiration_date := resource[name].certificate_body.expiration_date

	common_lib.expired(expiration_date)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].certificate_body", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].certificate_body should not have expired", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].certificate_body has expired", [resourceType, name]),
	}
}
