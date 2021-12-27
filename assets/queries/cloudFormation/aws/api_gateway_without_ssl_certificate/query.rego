package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(properties, "ClientCertificateId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties has ClientCertificateId defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties doesn't have ClientCertificateId defined", [name]),
	}
}
