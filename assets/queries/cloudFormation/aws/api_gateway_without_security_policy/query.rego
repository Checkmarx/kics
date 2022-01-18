package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::DomainName"

	properties := resource.Properties
	not common_lib.valid_key(properties, "SecurityPolicy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityPolicy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityPolicy is not defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityPolicy is defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::DomainName"

	tls := "TLS_1_2"
	resource.Properties.SecurityPolicy != tls

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityPolicy is %s", [name, tls]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityPolicy should be %s", [name, tls]),
	}
}
