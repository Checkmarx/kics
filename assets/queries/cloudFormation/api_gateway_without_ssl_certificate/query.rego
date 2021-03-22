package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	object.get(properties, "ClientCertificateId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties has ClientCertificateId defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties doesn't have ClientCertificateId defined", [name]),
	}
}
