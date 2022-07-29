package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	docs := input.document[i]

	not resource.client_certificate_id

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'client_certificate_id' is set",
		"keyActualValue": "Attribute 'client_certificate_id' is undefined",
	}
}
