package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_api_gateway_stage[name]

	not resource.client_certificate_id

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'client_certificate_id' should be set",
		"keyActualValue": "Attribute 'client_certificate_id' is undefined",
	}
}
